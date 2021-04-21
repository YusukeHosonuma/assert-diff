require "../spec_helper"
require "uri"

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

private def expected(typename)
  AnyHash.new(
    AnyObject.new(typename, [
      AnyProperty.new("int", AnyHash.new(42)),
      AnyProperty.new("float", AnyHash.new(1.2)),
      AnyProperty.new("bool", AnyHash.new(true)),
      AnyProperty.new("optional", AnyHash.new(nil)),
      AnyProperty.new("string", AnyHash.new("Hello")),
      AnyProperty.new("path", AnyHash.new("foo/bar/baz.cr")),
      AnyProperty.new("symbol", AnyHash.new(:foo)),
      AnyProperty.new("char", AnyHash.new('a')),
      AnyProperty.new("array", AnyHash.new([
        AnyHash.new(1),
        AnyHash.new(2),
      ])),
      AnyProperty.new("deque", AnyHash.new([
        AnyHash.new(1),
        AnyHash.new(2),
      ])),
      AnyProperty.new("set", AnyHash.new(Set{
        AnyHash.new(1),
        AnyHash.new(2),
      })),
      AnyProperty.new("hash", AnyHash.new({
        "one" => AnyHash.new(1),
        "two" => AnyHash.new(2),
      })),
      AnyProperty.new("tuple", AnyHash.new(
        AnyTuple.new([AnyHash.new(1), AnyHash.new(true)])
      )),
      AnyProperty.new("named_tuple", AnyHash.new(
        {"one" => AnyHash.new(1), "two" => AnyHash.new(2)}
      )),
      AnyProperty.new("time", AnyHash.new(
        Time.local(2016, 2, 15, 10, 20, 30, location: Time::Location.load("Asia/Tokyo"))
      )),
      AnyProperty.new("uri", AnyHash.new(URI.parse("http://example.com/"))),
      AnyProperty.new("json", AnyHash.new({"one" => AnyHash.new("1"), "two" => AnyHash.new("2")})),
      AnyProperty.new("color", AnyHash.new(AnyEnum.new(Color::Red))),
    ])
  )
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

    it "struct" do
      object.__to_json_any.should eq_diff expected(typename: "BasicTypesStruct")
    end

    it "class" do
      klass.__to_json_any.should eq expected(typename: "BasicTypesClass")
    end

    it "subclass" do
      B.new("B").__to_json_any.should eq AnyHash.new(
        AnyObject.new("B", [
          AnyProperty.new("a", AnyHash.new("A")),
          AnyProperty.new("b", AnyHash.new("B")),
        ])
      )
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
      expected = AnyHash.new(
        AnyObject.new("NestedClass", [
          AnyProperty.new("value", AnyHash.new(1)),
          AnyProperty.new("nested", AnyHash.new(
            AnyObject.new("NestedClass", [
              AnyProperty.new("value", AnyHash.new(2)),
              AnyProperty.new("nested", AnyHash.new(
                AnyObject.new("NestedClass", [
                  AnyProperty.new("value", AnyHash.new(3)),
                  AnyProperty.new("nested", AnyHash.new(nil)),
                ])
              )),
            ])
          )),
        ])
      )
      object.__to_json_any.should eq expected
    end
  end
end
