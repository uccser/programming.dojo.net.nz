
require 'net/smtp'

def send_email_test(from, to, subject, message)
	File.open("email_test", "a") do |f|
		f.puts "From: #{from}"
		f.puts "To: #{to}"
		f.puts "Subject: #{subject}"
		f.puts
		f.puts message
	end
end

def send_email(from, to, subject, message)
	Net::SMTP.start('localhost') do |smtp|
		smtp.open_message_stream(from, [to]) do |f|
			f.puts "From: #{from}"
			f.puts "To: #{to}"
			f.puts "Subject: #{subject}"
			f.puts
			f.puts message
		end
	end
end

def process!(path, request)
	params = request.params
	
	subject = params["subject"] || ""
	from = params["from"] || ""
	message = params["message"] || ""

	if request.post?
		errors = []
		if subject.size == 0
			errors << "Please specify a subject."
		end
		
		if message.size == 0
			errors << "Please specify a message."
		end
		
		if errors.size == 0
			response = send_email(from, "samuel@oriontransfer.org", "Website Contact: " + subject, message)
			
			if from.size == 0
				return redirect("success-no-reply", 302)
			else
				return redirect("success", 302)
			end
		end
	end
	
	request.controller do
		@subject = subject
		@from = from
		@message = message
		@errors = errors
	end
	
	return nil
end
