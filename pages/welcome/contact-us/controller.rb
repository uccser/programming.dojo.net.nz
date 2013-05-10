
require 'net/smtp'

def on_index(path, request)
	params = request.params

	if request.post?
		begin
			Mail.deliver do
				from params["from"]
				to 'samuel@oriontransfer.org'
				subject "Website Contact: #{params["subject"]}"
				body params["message"]
			end

			if params["from"].size == 0
				redirect! "success-no-reply"
			else
				redirect! "success"
			end
		end
	end
end
