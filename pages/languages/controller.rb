
def on_random(path, request)
	languages = %w(basic c cpp haskell java pascal perl php python ruby scheme smalltalk)
	
	redirect! languages[rand(languages.size)]
end

def process!(path, request)
	return passthrough(path, request)
end
