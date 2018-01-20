# Using `method_missing` allows us to intercept any method call. Here we use
# that to decorate every method call to a given object.

class LogDecorator

  def initialize(decorated)
    @decorated = decorated
  end

  def method_missing(method_name, *args)
    puts "~~> #{@decorated} received #{method_name} with (#{args.inspect})"
    @decorated.send(method_name, *args)
  end

end

str = LogDecorator.new("Hey ho let's go")

# This will print:
# ```
# ~~> Hey ho let's go received length with ([])
# 15
# ```
puts str.length
