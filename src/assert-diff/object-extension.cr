require "json"

# :nodoc:
module AssertDiff::Extension
  private macro to_hash
    hash = {
      {% for m in @type.instance_vars %}
      {{m.name.stringify}} => @{{m.name}}.__to_json_any,
      {% end %}
    }
    AnyHash.new(hash)
  end

  def __to_json_any : AnyHash
    to_hash
  end
end

# :nodoc:
class Object
  include AssertDiff::Extension
end

# :nodoc:
struct Char
  def __to_json_any : AnyHash
    AnyHash.new(self)
  end
end

# :nodoc:
class String
  def __to_json_any : AnyHash
    AnyHash.new(self)
  end
end

# :nodoc:
struct Path
  def __to_json_any : AnyHash
    AnyHash.new(self.to_s)
  end
end

# :nodoc:
struct Symbol
  def __to_json_any : AnyHash
    AnyHash.new(self)
  end
end

# :nodoc:
struct Bool
  def __to_json_any : AnyHash
    AnyHash.new(self)
  end
end

# :nodoc:
struct Int32
  def __to_json_any : AnyHash
    AnyHash.new(self)
  end
end

struct Int64
  def __to_json_any : AnyHash
    AnyHash.new(self)
  end
end

struct Float32
  def __to_json_any : AnyHash
    AnyHash.new(self)
  end
end

struct Float64
  def __to_json_any : AnyHash
    AnyHash.new(self)
  end
end

# :nodoc:
struct Nil
  def __to_json_any : AnyHash
    AnyHash.new(self)
  end
end

# :nodoc:
class Array
  def __to_json_any : AnyHash
    AnyHash.new(self.map &.__to_json_any)
  end
end

# :nodoc:
class Deque
  def __to_json_any : AnyHash
    self.to_a.__to_json_any
  end
end

# :nodoc:
struct Set
  def __to_json_any : AnyHash
    AnyHash.new(self.map(&.__to_json_any).to_set)
    # AnyHash.new(self.to_a.__to_json_any.to_set)
  end
end

# :nodoc:
class Hash
  def __to_json_any : AnyHash
    hash = {} of String => AnyHash
    self.each do |key, value|
      hash["#{key}"] = value.__to_json_any
    end
    AnyHash.new(hash)
  end
end

# :nodoc:
struct Tuple
  def __to_json_any : AnyHash
    AnyHash.new(AnyTuple.new(self.to_a.map(&.__to_json_any)))
  end
end

# :nodoc:
struct NamedTuple
  def __to_json_any : AnyHash
    hash = {} of String => AnyHash
    self.each do |key, value|
      hash["#{key}"] = value.__to_json_any
    end
    AnyHash.new(hash)
  end
end

# :nodoc:
struct Time
  def __to_json_any : AnyHash
    AnyHash.new(to_local)
  end
end

class URI
  def __to_json_any : AnyHash
    AnyHash.new(self)
  end
end

# :nodoc:
struct AnyHash
  def __to_json_any : AnyHash
    self
  end
end

# :nodoc:
struct JSON::Any
  def __to_json_any : AnyHash
    raw.__to_json_any
  end
end

# :nodoc:
struct Enum
  def __to_json_any : AnyHash
    AnyHash.new(AnyEnum.new(self))
  end
end
