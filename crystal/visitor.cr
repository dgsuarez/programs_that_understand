# No need to do any metaprogramming here since Crystal supports method
# overloading

module Visitable
  def accept(visitor)
    visitor.visit(self)
  end
end

class String; include Visitable; end
struct Int32; include Visitable; end

class Array
  def accept(visitor)
    visited = map { |element| element.accept(visitor) }
    visitor.visit(self, visited)
  end
end

class PrintVisitor
  def visit(string : String)
    "=#{string}="
  end

  def visit(fixnum : Int32)
    "!!#{fixnum}!!"
  end

  def visit(_array : Array, contents : Array)
    "<[#{contents.join(", ")}]>"
  end

end

visitor = PrintVisitor.new

puts ["asf", 1, 2, "jl"].accept(visitor) # <[=asf=, !!1!!, !!2!!, =jl=]>

