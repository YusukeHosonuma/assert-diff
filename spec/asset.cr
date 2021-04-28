require "uri"

enum Color
  Red
  Green
  Blue
end

struct A
  def initialize(@x : Int32, @y : Int32)
  end
end

struct B
  def initialize(@x : Int32, @y : Int32)
  end
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
    @color : Color,
    @array_of_hash : Array(Hash(String, Int32)),
    @array_of_array : Array(Array(Int32)),
    @array_of_object : Array(A)
  )
  end

  def self.before
    self.new(
      int: 42,
      float: 1.2,
      bool: true,
      optional: nil,
      string: "Hello",
      path: Path["foo/bar/baz.cr"],
      symbol: :foo,
      char: 'a',
      array: [1, 2],
      deque: Deque.new([1, 2]),
      set: Set{1, 2},
      hash: {"one" => 1, "two" => 2},
      tuple: {1, true},
      named_tuple: {one: 1, two: 2},
      time: Time.local(2016, 2, 15, 10, 20, 30, location: Time::Location.load("Asia/Tokyo")),
      uri: URI.parse("http://example.com/"),
      json: JSON::Any.new({"one" => JSON::Any.new("1"), "two" => JSON::Any.new("2")}),
      color: Color::Red,
      array_of_hash: [] of Hash(String, Int32),
      array_of_array: [] of Array(Int32),
      array_of_object: [] of A
    )
  end

  def self.after
    self.new(
      int: 43,
      float: 1.3,
      bool: false,
      optional: "string",
      string: "Goodbye",
      path: Path["foo/bar/hoge.cr"],
      symbol: :bar,
      char: 'b',
      array: [1, 3],
      deque: Deque.new([1, 3]),
      set: Set{1, 3},
      hash: {"one" => 1, "two" => 3},
      tuple: {1, false},
      named_tuple: {one: 1, two: 3},
      time: Time.local(2017, 2, 15, 10, 20, 30, location: Time::Location.load("Asia/Tokyo")),
      uri: URI.parse("http://example.com/foo"),
      json: JSON::Any.new({"one" => JSON::Any.new("1"), "two" => JSON::Any.new("3")}),
      color: Color::Blue,
      array_of_hash: [{"one" => 1, "two" => 2}],
      array_of_array: [[1, 2]],
      array_of_object: [A.new(1, 2)]
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
