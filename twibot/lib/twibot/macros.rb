module Twibot
  @@prompt = false

  def self.prompt=(p)
    @@prompt = f
  end

  module Macros
    def self.included(mod)
      @@bot = nil
    end

    def configure(&blk)
      bot.configure(&blk)
    end

    def message(pattern = nil, options = {}, &blk)
      add_handler(:message, pattern, options, &blk)
    end

    def reply(pattern = nil, options = {}, &blk)
      add_handler(:reply, pattern, options, &blk)
    end

    def tweet(pattern = nil, options = {}, &blk)
      add_handler(:tweet, pattern, options, &blk)
    end

    def twitter
      bot.twitter
    end

    alias_method :client, :twitter

    def post_tweet(msg, in_reply_to_status_id = nil)
      message = msg.respond_to?(:text) ? msg.text : msg
      puts message
      client.status(:post, message, in_reply_to_status_id)
    end

    def run?
      !@@bot.nil?
    end

   private
    def add_handler(type, pattern, options, &blk)
      bot.add_handler(type, Twibot::Handler.new(pattern, options, &blk))
    end

    def bot
      return @@bot unless @@bot.nil?

      begin
        @@bot = Twibot::Bot.new nil, true
      rescue Exception
        @@bot = Twibot::Bot.new(Twibot::Config.default << Twibot::CliConfig.new, true)
      end

      @@bot
    end

    def self.bot=(bot)
      @@bot = bot
    end
  end
end
