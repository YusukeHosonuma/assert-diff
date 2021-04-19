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
               Time |
               URI

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

  def to_s(io : IO) : Nil
    @raw.to_s(io)
  end
end
