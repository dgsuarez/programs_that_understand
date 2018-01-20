# In ruby there's no method overloading. This is a problem when implementing
# something like the Visitor pattern. One way to go around this is this one,
# Instead of having `visit(String s)`, we have `visit_string(s)`.
#
# When an object accepts the visitor, it uses it's own class name to generate
# the method it needs to call.
#
# One big advantage of doing it like this, besides general DRYness, is that by
# generating the method name dynamically, we can even distribute the
# `Visitable` module and reuse it wherever. If we had done some sort of
# non-dynamic case statement to dispatch, we'd have tied `Visitable` to a single
# use case (for every new place we'd want to add it, we'd need to update this
# case).

module Visitable
  def accept(visitor)
    method = "visit_#{self.class.name.downcase}"
    visitor.send(method, self)
  end
end

class Object; include Visitable; end

class Array
  def accept(visitor)
    visited = map { |element| element.accept(visitor) }
    visitor.visit_array(self, visited)
  end
end

class PrintVisitor
  def visit_string(string)
    "=#{string}="
  end

  def visit_fixnum(fixnum)
    "!!#{fixnum}!!"
  end

  def visit_array(_, contents)
    "<[#{contents.join(', ')}]>"
  end

end

visitor = PrintVisitor.new

puts ["asf", 1, 2, "jl"].accept(visitor) # <[=asf=, !!1!!, !!2!!, =jl=]>
