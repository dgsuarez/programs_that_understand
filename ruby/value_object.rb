# The whole idea of this is to have barebones "value object factory" that
# creates new classes for the given attribute names.

# This method will be invoked for a class object. For example, let's say a
# Money class. It'll add an `initialize` for the class with the given arguments
# as parameters, and it'll set the instance variable with the same name for
# each attribute.

def vo_initialize(attributes)
  define_method("initialize") do |values|
    attributes.zip(values).each do |attribute, value|
      instance_variable_set("@#{attribute}", value)
    end
  end
end

# This other method will add reader methods that return the value of each
# attribute

def vo_readers(attributes)
  attributes.each do |attribute|
    define_method(attribute) do
      instance_variable_get("@#{attribute}")
    end
  end
end

# Finally we have the factory, this returns a new instance of `Class` (so, a
# class!).  When we pass a block to `Class.new`, it gets executed in the
# context of the newly created class

def value_object(*attributes)
  Class.new do
    vo_initialize(attributes)
    vo_readers(attributes)
  end
end

# Tada!
Money = value_object("currency", "amount")
