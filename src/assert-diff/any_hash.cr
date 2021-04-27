require "uri"

# :nodoc:
struct AnyTuple(T)
  getter raw

  def initialize(@raw : Array(T))
  end

  def to_s(io : IO) : Nil
    io << "{" << @raw.join(", ") << "}"
  end
end

# :nodoc:
class AnyEnum
  getter type : String
  getter value : AnyHash

  def initialize(value : Enum)
    @type = typeof(value).to_s
    @value = AnyHash.new(value.to_s)
  end

  def ==(other : AnyEnum)
    value == other.value
  end

  def to_s(io : IO) : Nil
    io << @type << "::" << @value
  end
end

# :nodoc:
struct KeyValue(K, V)
  getter key, value

  def initialize(@key : K, @value : V)
  end
end

# :nodoc:
alias AnyProperty = KeyValue(String, AnyHash)

# :nodoc:
struct AnyObject
  getter typename, properties

  def initialize(@typename : String, @properties : Array(AnyProperty))
  end
end

# :nodoc:
struct AnyHash
  alias Type = Nil |
               Bool |
               Int32 |
               Int64 |
               Float32 |
               Float64 |
               Char |
               String |
               Symbol |
               Set(AnyHash) |
               Array(AnyHash) |
               Hash(String, AnyHash) |
               AnyTuple(AnyHash) |
               Time |
               URI |
               AnyEnum |
               AnyObject

  getter raw : Type

  def initialize(@raw : Type)
  end

  def to_s(io : IO) : Nil
    @raw.to_s(io)
  end
end
