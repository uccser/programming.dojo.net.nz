#!/usr/bin/env ruby
# Simple Operator Expression Parser

require 'set'

DEBUG = false

module Expression
	IDENTIFIER_REGEX = /[a-zA-Z]+/
	
	class Context
		def initialize(operators, values)
			@values = values
			@operators = operators
		end
    
		def value_of (key)
			@values[key]
		end
    
		def call (op, args)
			@operators.call(op, args)
		end
	end
  
	class Constant
		def initialize(value)
			@value = value
		end
    
		def evaluate (ctx)
			return @value
		end
	end
  
	class Identifier
		def initialize(name)
			@name = name
		end
    
		def evaluate (ctx)
			ctx.value_of(@name)
		end
	end
  
	class Operator
		def initialize(name, args = [])
			@name = name
			@args = args
		end
    
		def name
			@name
		end
  
		def evaluate (ctx)
			ctx.call(@name, @args.collect { |a| a.evaluate(ctx) })
		end
    
		def args
			@args
		end
		
		def to_s
			@name
		end
	end
  
	class Brackets
		def initialize(node)
			@node = node
		end
    
		def evaluate (ctx)
			@node.evaluate(ctx)
		end
	end

	class Parser
		def initialize(ops, expr)
			@identifiers = []
			@operators = ops
    
			# Tokens and expressions line up
			@expressions = []
			@tokens = []
      
			@top = nil
    
			parse(expr)
		end
    
		def evaluate (ctx)
			@expressions.collect do |expr|
				expr != nil ? expr.evaluate(ctx) : nil
			end
		end
  
		def identifiers
			@identifiers
		end
  
		def tokens
			@tokens
		end
		private
		def parse(expr)
			symbols = @operators.keys + ["(", ")"]
			tokenizer = Regexp.union(Regexp.union(*symbols), IDENTIFIER_REGEX)
    
			@tokens = expr.scan(tokenizer)
			@expressions = [nil] * @tokens.size
    
			@identifiers = Set.new(expr.scan(IDENTIFIER_REGEX))
      
			@top, i = process_expression
      
			if DEBUG
				puts "Processed #{i} tokens..."
				puts "Tokens: " + @tokens.join(" ")
				puts @top.inspect
				puts @expressions.inspect
			end
		end
    
		def process_expression(i = 0)
			ast = []
			ops = {}
			while i < @tokens.size
				t = @tokens[i]
        
				if t == "("
					result, i = process_expression(i+1)
					ast += result
				elsif t == ")"
					break
				else        
					result = process_token(i)
					ast << result
				end
        
				if result.class == Operator
					ops[result.name] ||= []
					# Store the index
					ops[result.name] << (ast.size - 1)
				end
             
				i += 1
			end
      
			#puts ast.inspect
      
			# We need to sort the list of operators now
			# [c, infix, prefix, c]
      
			@operators.order.each do |name|
				op_kind = @operators.kind(name)
				next unless ops[name]
        
				case op_kind
				when :prefix
					ops[name].reverse.each do |loc|
						op = ast[loc]
						rhs = find_subexpression(ast, loc, RHS_SEARCH)
						
						raise RuntimeError.new("Could not find right hand side of operator #{op}") unless rhs
						
						op.args << ast[rhs]
						ast[rhs] = nil
					end
				when :infix
					ops[name].each do |loc|
						op = ast[loc]
						lhs = find_subexpression(ast, loc, LHS_SEARCH)
						rhs = find_subexpression(ast, loc, RHS_SEARCH)
						
						raise RuntimeError.new("Could not find left hand side of operator #{op}") unless lhs
						raise RuntimeError.new("Could not find right hand side of operator #{op}") unless rhs
						
						op.args << ast[lhs]
						op.args << ast[rhs]
						ast[lhs] = ast[rhs] = nil
					end
				when :postfix
					ops[name].each do |loc|
						op = ast[loc]
						lhs = find_subexpression(ast, loc, LHS_SEARCH)
						
						raise RuntimeError.new("Could not find left hand side of operator #{op}") unless lhs
						
						op.args << ast[lhs]
						ast[rhs] = nil
					end
				end
			end
      
			return [ast.uniq, i]
		end
    
		RHS_SEARCH = 1
		LHS_SEARCH = -1

		def find_subexpression(ast, loc, dir)
			while loc >= 0 && loc < ast.size
				loc += dir
				return loc if ast[loc] != nil
			end

			return nil
		end
    
		def process_token(i) 
			t = @tokens[i]

			if @operators.key? t
				tok = Operator.new(t)
			elsif t.match IDENTIFIER_REGEX
				tok = Identifier.new(t)
			else
				tok = Constant.new(t)
			end
      
			@expressions[i] = tok
			return tok
		end
	end

	TYPE = 0
	FUNC = 1
	class Operators
		include Enumerable
		
		def initialize
			@operators = {}
			@order = []
		end
  
		def add(symbol, kind, &block)
			@operators[symbol] = [kind, block]
			@order << symbol
		end
    
		attr :order
		attr :operators
  
		def keys
			@operators.keys
		end
  
		def key? k
			@operators.key? k
		end
  
		def kind k
			@operators[k][0]
		end
  
		def call(k, args)
			@operators[k][1].call(*args)
		end
		
		def each(&block)
			@order.each(&block)
		end
	end
end
