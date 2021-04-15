require "./spec_helper"
require "json"

struct Pet
  def initialize(@name : Array(String), @meta : Hash(String, Int32))
  end
end

struct Person
  def initialize(@name : String, @age : Int32, @pet : Pet)
  end
end

class Foo
  def initialize(@item : X)
  end
  def test
    pp! @item.x
    pp! @item.y
    pp! @item.z
  end
end

abstract class X
  def z
    "Xz: #{typeof(self)}"
  end
end

class A < X
  def initialize(@a : String)
  end

  def z
    "Az: #{typeof(self)}"
  end
end

class B < A
  def initialize(@b : String)
    super("super")
  end

  def z
    "Bz: #{typeof(self)}"
  end
end

struct Point
  include JSON::Serializable

  property x : Int32
  property y : Int32

  def initialize(@x, @y)
  end
end

describe ".assert_diff" do
  it "works" do
    # pp! A.new("hello").__to_h
    # pp! B.new("hello").__to_h
    # pp! B.new("hello").__to_h
    # pp! B.new("hello").x
    # pp! B.new("hello").y
    # pp! B.new("hello").__to_h
    # pp! Foo.new(B.new("hello")).test
    # pp! Foo.new(B.new("hello")).__to_h

    # hash = Person.new("tobi", 17,
    #   Pet.new(["pochi", "ポチ"], {
    #     "a" => 1,
    #     "b" => 2,
    #   })
    # ).__to_h
    # puts hash.to_json

    # pp! p.is_a?(JSON::Serializable)
  end
end
