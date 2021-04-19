require "../spec_helper"
require "uri"

private enum Color
  Red
  Green
  Blue
end

private struct BasicTypesStruct
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

private class BasicTypesClass
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

private class X
  def initialize(@x : A)
  end
end

private abstract class A
  def initialize(@a : String)
  end
end

private class B < A
  def initialize(@b : String)
    super("A")
  end
end

private class NestedClass
  include AssertDiff::Extension

  property value : Int32
  property nested : NestedClass?

  def initialize(
    @value : Int32,
    @nested : NestedClass?
  )
  end
end

describe Object do
  describe "#__to_json_any" do
    object = BasicTypesStruct.new(
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
      color: Color::Red
    )
    klass = BasicTypesClass.new(
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
      color: Color::Red
    )
    expected = AnyHash.new({
      "int"      => AnyHash.new(42),
      "float"    => AnyHash.new(1.2),
      "bool"     => AnyHash.new(true),
      "optional" => AnyHash.new(nil),
      "string"   => AnyHash.new("Hello"),
      "path"     => AnyHash.new("foo/bar/baz.cr"),
      "symbol"   => AnyHash.new(":foo"),
      "char"     => AnyHash.new('a'),
      "array"    => AnyHash.new([
        AnyHash.new(1),
        AnyHash.new(2),
      ]),
      "deque" => AnyHash.new([
        AnyHash.new(1),
        AnyHash.new(2),
      ]),
      "set" => AnyHash.new([
        AnyHash.new(1),
        AnyHash.new(2),
      ]),
      "hash" => AnyHash.new({
        "one" => AnyHash.new(1),
        "two" => AnyHash.new(2),
      }),
      "tuple"       => AnyHash.new([AnyHash.new(1), AnyHash.new(true)]),
      "named_tuple" => AnyHash.new({"one" => AnyHash.new(1), "two" => AnyHash.new(2)}),
      "time"        => AnyHash.new("2016-02-15 10:20:30 +09:00"),
      "uri"         => AnyHash.new("http://example.com/"),
      "json"        => AnyHash.new({"one" => AnyHash.new("1"), "two" => AnyHash.new("2")}),
      "color"       => AnyHash.new("Red"),
    })

    it "struct" do
      object.__to_json_any.should eq_diff expected
    end

    it "class" do
      klass.__to_json_any.should eq expected
    end

    it "subclass" do
      B.new("B").__to_json_any.should eq AnyHash.new({
        "a" => AnyHash.new("A"),
        "b" => AnyHash.new("B"),
      })
    end

    pending "has abstract class" do
      X.new(B.new("B")).__to_json_any.should eq ({
        "x" => {
          "a" => "A",
          "b" => "B", # TODO: Not included in result, why?
        },
      })
    end

    it "nested class" do
      object = NestedClass.new(1,
        NestedClass.new(2,
          NestedClass.new(3, nil)
        )
      )
      expected = AnyHash.new({
        "value"  => AnyHash.new(1),
        "nested" => AnyHash.new({
          "value"  => AnyHash.new(2),
          "nested" => AnyHash.new({
            "value"  => AnyHash.new(3),
            "nested" => AnyHash.new(nil),
          }),
        }),
      })
      object.__to_json_any.should eq expected
    end
  end
end
