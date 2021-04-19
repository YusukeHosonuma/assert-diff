require "../spec_helper"

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
    @hash : Hash(String, Int32),
    @named_tuple : NamedTuple(one: Int32, two: Int32),
    @json : JSON::Any
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
    @hash : Hash(String, Int32),
    @named_tuple : NamedTuple(one: Int32, two: Int32),
    @json : JSON::Any
  )
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
      hash: {"one" => 1, "two" => 2},
      named_tuple: {one: 1, two: 2},
      json: JSON::Any.new({"one" => JSON::Any.new("1"), "two" => JSON::Any.new("2")})
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
      hash: {"one" => 1, "two" => 2},
      named_tuple: {one: 1, two: 2},
      json: JSON::Any.new({"one" => JSON::Any.new("1"), "two" => JSON::Any.new("2")})
    )
    expected = {
      "int"         => 42,
      "float"       => 1.2,
      "bool"        => true,
      "optional"    => nil,
      "string"      => "Hello",
      "path"        => "foo/bar/baz.cr",
      "symbol"      => ":foo",
      "char"        => "a",
      "array"       => [1, 2],
      "deque"       => [1, 2],
      "hash"        => {"one" => 1, "two" => 2},
      "named_tuple" => {"one" => 1, "two" => 2},
      "json"        => {"one" => "1", "two" => "2"},
    }

    it "struct" do
      object.__to_json_any.should eq expected
    end

    it "class" do
      klass.__to_json_any.should eq expected
    end

    it "subclass" do
      B.new("B").__to_json_any.should eq ({
        "a" => "A",
        "b" => "B",
      })
    end

    it "nested class" do
      object = NestedClass.new(1,
        NestedClass.new(2,
          NestedClass.new(3, nil)
        )
      )
      expected = {
        "value"  => 1,
        "nested" => {
          "value"  => 2,
          "nested" => {
            "value"  => 3,
            "nested" => nil,
          },
        },
      }
      object.__to_json_any.should eq expected
    end
  end
end
