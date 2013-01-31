
require 'timeout'

module RegisterMachineInterpreter
	class Context
		def initialize
			@registers = {}
			@states = {}

			add_state(State.parse(".: ."))
		end

		def registers
			@registers
		end

		def states
			@states
		end

		def starting_state
			@states["S"] || @states["1"]
		end

		def add_state(state)
			@states[state.name] = state
		end

		def set_count(register, count)
			@registers[register] = count
		end

		def add_stone(register)
			#puts "Adding stone to #{register}"
			@registers[register] ||= 0
			@registers[register] += 1
		end

		def remove_stone(register)
			@registers[register] ||= 0

			if (@registers[register] > 0)
				#puts "Removing stone from #{register}"
				@registers[register] -= 1
				return true
			end

			#puts "No stones left in #{register}!!"
			return false
		end

		def process_state(state)
			return nil if (state.is_halt)

			if (state.is_addition)
				add_stone(state.register)
				return @states[state.next_state('+')]
			elsif (state.is_removal)
				if (remove_stone(state.register))
					return @states[state.next_state('-')]
				else
					return @states[state.next_state('e')]
				end
			end

		end
	end

	class State
		def initialize(name, register, operations)
			@name = name
			@register = register
			@operations = operations || {}
		end

		def name
			@name
		end

		def register
			@register
		end

		def self.parse(line)    
			line.match(/([a-zA-Z0-9\.]+):\s*?([a-zA-Z\.])\s*?(.*)$/)

			#puts "#{$1}, #{$2}, #{$3}"

			name = $1.strip
			register = $2.strip

			next_states = $3.split
			operations = {}
			next_states.each_with_index do |op,i| 
				operations[op] = next_states[i+1] if i % 2 == 0
			end

			#puts operations.inspect

			if operations.size == 0 && register != "."
				puts "Invalid state line #{line}. No operations but name is not '.' (i.e. halt)!"
				return nil
			end

			return State.new(name, register, operations)
		end

		def is_halt
			@register == "."
		end

		def is_addition
			@operations.has_key? "+"
		end

		def is_removal
			@operations.has_key? "-"
		end

		def next_state(name)
			@operations[name]
		end

		def to_s
			ops = []
			@operations.each { |op,val| ops << "#{op} #{val}"}

			"#{name}: #{register} #{ops.join(' ')}"
		end
	end

	def self.evaluate(function)
		return if function == nil

		buffer = StringIO.new

		error = false
		code = function.split(/\r\n|\r|\n/)

		program = Context.new

		code.delete_if do |line|
			if line.match(/([a-zA-Z])\s*?=\s*?([0-9]+)/)
				program.set_count($1, $2.to_i)
				
				true
			elsif line.match(/^\s*#/) || line.match(/^\s*$/)
				true
			end
		end

		buffer.puts "Registers at start:"
		program.registers.each do |r,v|
			buffer.puts "\t#{r} = #{v}"
		end

		code.each do |line|
			begin
				state = State.parse(line)
			rescue
				buffer.puts "Error parsing \"#{line}\""
				error = true
			end
			program.add_state(state) if (state != nil)
		end

		unless error
			buffer.puts "Program"
			program.states.each do |k,v|
				puts "\t" + v.to_s
			end

			current_state = program.starting_state
			
			if current_state == nil
				buffer.puts "Warning: Could not determine starting state (must be '1' or 'S')."
			end

			buffer.puts "State transitions: "
			count = 0
			begin
				Timeout.timeout(3) do
					while (current_state != nil) do
						buffer.write current_state.name + " "
						current_state = program.process_state(current_state)

						if current_state && current_state.next_state('?')
							buffer.puts
							program.registers.each do |r,v|
								buffer.puts "\t#{r} = #{v}"
							end
						end

						count += 1
					end
				end
			rescue Timeout::Error
				buffer.puts "The program ran out of time!"
			end

			buffer.puts
			buffer.puts "#{count} states evaluated."
			buffer.puts "Registers at halt:"
			program.registers.each do |r,v|
				buffer.puts "\t#{r} = #{v}"
			end
			
			return buffer.string
		end
	end
end
