#!/opt/local/bin/ruby

require "rubygems"
require "system_timer"
require 'twibot/lib/twibot'
require "htmlentities"
require "pp"
require "gist"



$PROGRAM_NAME = ''
ENV.clear

def safe_eval(str)

	str.gsub!(/^@rubx\s*:? ?/, '')
	coder = HTMLEntities.new
	str = coder.decode(str)

	puts "Evaluting: #{str}"

#	return "no infinite loops allowed, sorry!" if str =~ /loop/
#	return "no threads execution allowed, sorry!" if str =~ /Thread/
	return "no more abort traps, please! It makes me die!" if str =~ /loop\s*&:p/
	return ":-*" if str =~ /allocate/ and str =~ /pre_match/

	res = nil
	begin
		SystemTimer.timeout_after(1) do
      res = Thread.start {
        eval %{
					YAML = nil
					def printf(*args)
						sprintf(args)
					end
					def puts(*args)
						args.to_s
					end
					def print(*args)
						args.to_s
					end
					def p(*args)
						args.to_s
					end
					def pp(*a)
						a.to_s
					end
					def putc(*args)
						args.to_s
					end
          def caller(*args)
            "" 
          end
				}
				$SAFE = 4               
				eval(str)
			}.value.pretty_inspect.chomp

		end
	rescue TypeError => ex
		res = "#{ex.class}: #{ex.message}"
	rescue SyntaxError => ex
		res = "#{ex.class}: #{ex.to_s}"
	rescue SecurityError => ex
		res = "operation not permitted; #{ex.message}"
	rescue TypeError => ex
		res = "#{ex.class}: #{ex.to_s}"
	rescue NameError => ex
		res = "#{ex.class}: #{ex.to_s}"
	rescue ArgumentError => ex
		res = "#{ex.class}: #{ex.to_s}"
	rescue Timeout::Error => ex
		res = "operation took more time than expected; execution aborted!"
		# meh!
	rescue ZeroDivisionError => ex
		res = "operation not permitted; zero division"
	ensure
		res = "(nothing returned)" unless res
		eval %q{
				def printf(*args)
					Kernel.printf(*args)
				end
				def puts(*args)
					Kernel.puts(*args)
				end
				def print(*args)
					Kernel.print(*args)
				end
				def pp(*a)
					Kernel.pp(*a)
				end
				def p(*args)
					Kernel.p(*args)
				end
				def putc(*args)
					Kernel.putc(args)
				end
        def caller(*args)
          Kernel.caller(args)
        end
		}
	end

	res.gsub!(/ at level 4$/, '')
	res.gsub!(/^.+?Error:.*':/, 'error:')
	res.gsub!("`safe_eval'", "`eval'")
	res.gsub!(/operation not permitted; .+?:\d+:/, 'operation not permitted ')
	res.gsub!(/operation not permitted.*':/, 'operation not permitted:')

	return res
end

reply do |message, params|
	if message.text =~ /^@rubx/
		ret = "#{safe_eval(message.text)}"
		reply_to = "@#{message.user.screen_name}"
		msg = "#{reply_to} #{ret}"

		if msg.size > 140
			gist = Gistit.new
			url = "http://gist.github.com/#{gist.paste(ret)}"
			post_tweet("#{msg[0, 140 - url.size - 3]} > #{url}", message.id)
		else
			post_tweet(msg, message.id)
		end

	else
		puts "Discarded: #{message.text}"
	end

end


