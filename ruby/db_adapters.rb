# This is a classic metaprogramming use case: Avoid repeating yourself when you
# need to initialize a class based on it's name

module Adapters
  class MysqlAdapter; end

  class PostgresAdapter; end

  class SqlserverAdapter; end

  class OracleAdapter; end
end

# Using `const_get` we can resolve a class name (a string), into a real
# reference to the class.

def adapter(db_name)
  adapter_class_name = "#{db_name.capitalize}Adapter"

  Adapters.const_get(adapter_class_name)
end

p adapter(:sqlserver).new
