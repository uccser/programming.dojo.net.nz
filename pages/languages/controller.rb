
prepend Actions

on 'random' do
	languages = %w(basic c c-sharp cpp haskell java pascal perl php python ruby scheme smalltalk swift)
	
	redirect! languages[rand(languages.size)]
end
