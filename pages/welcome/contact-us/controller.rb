
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
				return redirect("success-no-reply")
			else
				return redirect("success")
			end
		end
	end
	
	return nil
end
