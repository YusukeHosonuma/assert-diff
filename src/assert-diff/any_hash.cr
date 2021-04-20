require "uri"

# :nodoc:
struct AnyTuple(T)
  getter raw : Array(T)

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
struct AnyObject
  getter typename : String
  getter properties : Hash(String, AnyHash)

  def initialize(@typename : String, @properties : Hash(String, AnyHash))
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

  def as_s : String
    @raw.as(String)
  end

  def as_s? : String?
    as_s if @raw.is_a?(String)
  end

  def as_a : Array(AnyHash)
    @raw.as(Array)
  end

  def as_a? : Array(AnyHash)?
    as_a if @raw.is_a?(Array)
  end

  def as_h : Hash(String, AnyHash)
    @raw.as(Hash)
  end

  def as_h? : Hash(String, AnyHash)?
    as_h if @raw.is_a?(Hash)
  end

  def as_o : AnyObject
    @raw.as(AnyObject)
  end

  def as_o? : AnyObject?
    as_o if @raw.is_a?(AnyObject)
  end

  def to_s(io : IO) : Nil
    @raw.to_s(io)
  end
end
