require "json"

# :nodoc:
module AssertDiff::Extension
  private macro to_hash
    {% if @type.abstract? %}
      raise "abstract class is not supported yet."
    {% else %}
      hash = {
        {% for m in @type.instance_vars %}
        {{m.name.stringify}} => @{{m.name}}.__to_json_any,
        {% end %}
      }
      JSON::Any.new(hash)
      {% end %}
  end

  def __to_json_any : JSON::Any
    to_hash
  end
end

# :nodoc:
class Object
  include AssertDiff::Extension
end

# :nodoc:
struct Char
  def __to_json_any : JSON::Any
    JSON::Any.new("#{self}")
  end
end

# :nodoc:
class String
  def __to_json_any
    JSON::Any.new(self)
  end
end

# :nodoc:
struct Path
  def __to_json_any
    JSON::Any.new(self.to_s)
  end
end

# :nodoc:
struct Symbol
  def __to_json_any
    JSON::Any.new(":" + self.to_s)
  end
end

# :nodoc:
struct Bool
  def __to_json_any
    JSON::Any.new(self)
  end
end

# :nodoc:
struct Number
  def __to_json_any
    JSON.parse(self.to_s)
  end
end

# :nodoc:
struct Nil
  def __to_json_any
    JSON::Any.new(self)
  end
end

# :nodoc:
class Array
  def __to_json_any
    JSON::Any.new(self.map &.__to_json_any)
  end
end

# :nodoc:
class Deque
  def __to_json_any
    self.to_a.__to_json_any
  end
end

# :nodoc:
struct Set
  def __to_json_any
    self.to_a.__to_json_any
  end
end

# :nodoc:
class Hash
  def __to_json_any
    hash = {} of String => JSON::Any
    self.each do |key, value|
      hash["#{key}"] = value.__to_json_any
    end
    JSON::Any.new(hash)
  end
end

# :nodoc:
struct Tuple
  def __to_json_any
    self.to_a.__to_json_any
  end
end

# :nodoc:
struct NamedTuple
  def __to_json_any
    hash = {} of String => JSON::Any
    self.each do |key, value|
      hash["#{key}"] = value.__to_json_any
    end
    JSON::Any.new(hash)
  end
end

struct Time
  def __to_json_any
    JSON::Any.new(self.to_local.to_s)
  end
end

# :nodoc:
struct JSON::Any
  def __to_json_any
    self
  end
end

struct Enum
  def __to_json_any
    JSON::Any.new(self.to_s)
  end
end
