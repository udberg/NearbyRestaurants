require 'telegram/bot'
require 'google_places'

token = '1575408463:AAEcC7qwpT-7Mqm2sCuU6UGfBP9r4_s0Wj4'
@googleClient = GooglePlaces::Client.new('YOUR-GOOGLE-PLACES-API-TOKEN')

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    if message.location
      l = message.location
      restaurants = @googleClient.spots(l.latitude, l.longitude, :types => ['restaurant','food'], :radius => 500)
      for r in restaurants
        bot.api.send_location(chat_id: message.chat.id, latitude: r.lat, longitude: r.lng)
      end
    end
    case message.text
      when '/food'
        kb = [Telegram::Bot::Types::KeyboardButton.new(text: 'Show me your location', request_location: true)]
        markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
        bot.api.send_message(chat_id: message.chat.id, text: 'Hey!', reply_markup: markup)
    end
  end
end