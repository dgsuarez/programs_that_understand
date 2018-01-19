# The whole idea of this is to have barebones value object macro that
# creates new classes for the given class & attribute names.

# Inside a crystal macro the rules change, instead of executing its code it
# returns it, interpolating the stuff between {}. Parameters are not evaluated,
# they are received as AST nodes. When we invoke a macro, it gets replaced by
# its expansion (the result of its execution) at compiletime, not runtime

macro vo_initialize(*attributes)
  def initialize({{attributes.join(", ").id}})
    {% for attribute in attributes %}
      @{{attribute.var}} = {{attribute.var}}
    {% end %}
  end
end

macro vo_readers(*attributes)
  {% for attribute in attributes %}
    def {{attribute.var}}
      @{{attribute.var}}
    end
  {% end %}
end

# Note that this macro "calls" other macros. The compiler will expand all macros
# before actually compiling the code, here it will need to do a couple of expansions,
# one for the class, another for the vo_ methods

macro value_object(name, *attributes)
  class {{name}}
    vo_initialize({{*attributes}})
    vo_readers({{*attributes}})
  end
end

# The compiler  will end up seeing a regular class here once all the expansions have
# happened

value_object(Money, currency : String, amount : Int32)

salary = Money.new("$", 21)
