
require 'expression'

class Array
	def map_to(with)
		r = {}

		each_with_index { |v,i| r[v] = with[i] }

		return r
	end
end

module TruthTableSolver
	class BinarySequence
		def initialize(sz)
			@size = sz
			@current = [0] * @size
		end

		def current
			@current.reverse.collect { |v| v == 1 } 
		end

		def calculate_next
			k = 0
			@current[k] += 1

			while k < (@size-1) && @current[k] == 2 
				@current[k] = 0
				k = k + 1
				@current[k] += 1
			end

			return @current[@size-1] != 2
		end

		def each &block
			begin
				yield(*current)
			end while calculate_next
		end

		def collect &block
			r = []
			begin
				r << yield(*current)
			end while calculate_next

			return r
		end
	end
	
	class Evaluator
		def display(value)
			if value == true || value == 1
				return "1"
			elsif value == false || value == 0
				return "0"
			elsif value == "|"
				return "|"
			elsif value == nil
				return " "
			end

			return "?"
		end
	
		def operators
			unless @operators
				@operators = Expression::Operators.new
				@operators.add("1", :void) { true }
				@operators.add("0", :void) { false }
				@operators.add("~", :prefix) { |a| !a }
				@operators.add("+", :infix) { |a,b| (a & !b) | (b & !a) } #xor
				@operators.add("&", :infix) { |a,b| a & b }
				@operators.add("|", :infix) { |a,b| a | b }
				@operators.add("->", :infix) { |a,b| a ? b : true }
				@operators.add("<->", :infix) { |a,b| a == b }
				@operators.add("/", :void) { "|" }
			end
		
			return @operators
		end
	
		def evaluate(function)
			return if function == nil
		
			expr = Expression::Parser.new(self.operators, function)
			seq = BinarySequence.new(expr.identifiers.size)
			params = expr.identifiers.sort

			terms = params + ["|"] + expr.tokens
			results = seq.collect { |*v| v + ["|"] + expr.evaluate(Expression::Context.new(@operators, params.map_to(v))) }

			buffer = StringIO.new

			header = terms.join("  ")
			buffer.puts header
			buffer.puts "-" * header.size

			results.each do |r|
				buffer.puts
				r.each_with_index do |v, i|
					v = display(v)
					p = terms[i].size - 1

					buffer.write "#{" " * p}#{v}  "
				end
			end
	
			buffer.puts
		
			return buffer.string
		end
	end
end