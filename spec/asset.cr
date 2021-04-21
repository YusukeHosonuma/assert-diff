require "uri"

enum Color
  Red
  Green
  Blue
end

struct BasicTypesStruct
  def initialize(
    @int : Int32,
    @float : Float64,
    @bool : Bool,
    @optional : String?,
    @string : String,
    @path : Path,
    @symbol : Symbol,
    @char : Char,
    @array : Array(Int32),
    @deque : Deque(Int32),
    @set : Set(Int32),
    @hash : Hash(String, Int32),
    @tuple : Tuple(Int32, Bool),
    @named_tuple : NamedTuple(one: Int32, two: Int32),
    @time : Time,
    @uri : URI,
    @json : JSON::Any,
    @color : Color
  )
  end
end

struct Rectangle
  def initialize(@origin : Point, @width : Int32, @height : Int32, @comment : String)
  end
end

struct Point
  def initialize(@x : Int32, @y : Int32)
  end
end
