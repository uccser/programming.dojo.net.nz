
prepend Actions

on 'random' do
	languages = %w(basic c c-sharp cpp haskell java pascal perl php python ruby scheme smalltalk)
	
	redirect! languages[rand(languages.size)]
end
