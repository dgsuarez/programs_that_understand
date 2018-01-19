# This is a simple validation engine. With a small amount of code, and using
# very few metaprogramming tricks, it is concise, extensible and unsurprising
# in it's behavior.

# Here are the instance methods for our validable object
module Validable

  def valid?
    failed_validations.empty?
  end

  def validation_errors
    failed_validations.map(&:error_message)
  end

  private

  # In order to see if any validation is failed, we get the validations from
  # the class, for each we retrieve the field it's validating against, and we use
  # send to retrieve it's value in order for the validation to check.

  def failed_validations
    self.class.validations.reject do |validation|
      field_value = send(validation.field_name)
      validation.valid?(field_value)
    end
  end

end

# These are the class methods for the validables
module Validations

  attr_reader :validations

  def validates_format(field_name, format)
    validation = FormatValidation.new(field_name, format)
    add_validation(validation)
  end

  def validates_type(field_name, type)
    validation = TypeValidation.new(field_name, type)
    add_validation(validation)
  end

  def add_validation(validation)
    @validations ||= []

    @validations << validation
  end
end

class FormatValidation

  attr_reader :field_name

  def initialize(field_name, regex)
    @field_name = field_name
    @regex = regex
  end

  def valid?(field_value)
    @regex =~ field_value
  end

  def error_message
    "#{field_name} doesn't match #{@regex}"
  end
end

class TypeValidation

  attr_reader :field_name

  def initialize(field_name, type)
    @field_name = field_name
    @type = type
  end

  def valid?(field_value)
    field_value.is_a?(@type)
  end

  def error_message
    "#{field_name} is not a #{@type}"
  end
end

class MaxValidation

  attr_reader :field_name

  def initialize(field_name, max_value)
    @field_name = field_name
    @max_value = max_value
  end

  def valid?(field_value)
    field_value <= @max_value
  end

  def error_message
    "#{field_name} is bigger than #{@max_value}"
  end
end

class Person
  include Validable
  extend Validations

  validates_type :name, String
  validates_type :phone, String
  validates_type :age, Integer

  validates_format :name, /^[A-Z]/
  validates_format :phone, /\d{3}-\d{3}-\d{3}/

  # We can have ad-hoc validations even if we don't have the nice
  # `validates_...` syntax for them
  add_validation MaxValidation.new(:age, 140)

  attr_reader :name, :phone, :age

  def initialize(name, phone, age)
    @name = name
    @phone = phone
    @age = age
  end
end

p Person.new("Diego", "111-212-213", 89).valid?

