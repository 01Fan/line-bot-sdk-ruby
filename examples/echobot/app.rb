require 'sinatra'   # gem 'sinatra'
require 'line/bot'  # gem 'line-bot-api'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["7f8a2e25753fec104b5b6f669382fd8f"]
    config.channel_token = ENV["Cd5Nt2bjhLvGDls3XCWjtJ6uXOOM3e+1cHvb+XQaOQDo4S1A8jJGikrHQ2ZbWNdj9KYIYr+tv1McXnKpcvTIuUoh6RVz3hMo+1Riu8n4PiUZoDDEy15YWGXz8om/SbHxeIfgEzlb3AEpy189Qog8FgdB04t89/1O/w1cDnyilFU"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)

  events.each { |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)
      end
    end
  }

  "OK"
end
