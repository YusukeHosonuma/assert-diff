require "json"

# :nodoc:
module AssertDiff
  module Extension
    private macro to_hash
      {% if @type.abstract? %}
        raise "abstract class is not supported yet."
      {% else %}
        {
          {% for m in @type.instance_vars %}
          {{m.name}}: @{{m.name}}.__to_h,
          {% end %}
        }
      {% end %}
    end

    def __to_h
      to_hash
    end
  end
end

# :nodoc:
class Object
  include AssertDiff::Extension
end

# :nodoc:
struct Char
  def __to_h
    "#{self}"
  end
end

# :nodoc:
class String
  def __to_h
    self
  end
end

# :nodoc:
struct Bool
  def __to_h
    self
  end
end

# :nodoc:
struct Number
  def __to_h
    self
  end
end

# :nodoc:
struct Nil
  def __to_h
    self
  end
end

# :nodoc:
class Array
  def __to_h
    self.map &.__to_h
  end
end

# :nodoc:
class Hash
  def __to_h
    self.to_h
  end
end

# :nodoc:
struct NamedTuple
  def __to_h
    self.to_h
  end
end

# :nodoc:
struct JSON::Any
  def __to_h
    case self
    when .as_h?
      self.as_h
    when .as_a?
      self.as_a
    else
      self.to_s # works maybe.
    end
  end
end
