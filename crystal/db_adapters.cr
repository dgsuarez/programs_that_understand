# This is a classic metaprogramming use case: Avoid repeating yourself when you
# need to initialize a class based on it's name

module Adapters
  class MysqlAdapter; end
  class PostgresAdapter; end
  class SqlserverAdapter; end
  class OracleAdapter; end
end


# This macro expands to a case statement with branches like
#    when "MysqlAdapter" then Adapters::MysqlAdapter

macro class_from_name(container_namespace, class_name)
  case {{class_name}}
    {% for const in container_namespace.resolve.constants %}
      when "{{const}}" then {{container_namespace}}::{{const}}
    {% end %}
    else raise "No adapter found for #{ {{class_name}} }"
  end
end

def adapter(name)
  adapter_class_name = "#{name.to_s.capitalize}Adapter"
  class_from_name(Adapters, adapter_class_name)
end

puts adapter(:oracle).new
