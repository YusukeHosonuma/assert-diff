require "../spec_helper"

struct Rectangle
  def initialize(@origin : Point, @width : Int32, @height : Int32)
  end
end

struct Point
  def initialize(@x : Int32, @y : Int32)
  end
end

describe ".print_diff" do
  it "has no diff" do
    io = IO::Memory.new
    a = Rectangle.new(Point.new(0, 0), 4, 3)
    b = a
    print_diff(a, b, io)
    io.to_s.gsub(/\e.+?m/, "").should eq <<-EOF
    No diffs.
    EOF
  end

  it "has diff" do
    io = IO::Memory.new
    a = Rectangle.new(Point.new(0, 0), 4, 3)
    b = Rectangle.new(Point.new(0, 1), 4, 7)
    print_diff(a, b)
    print_diff(a, b, io)
    io.to_s.gsub(/\e.+?m/, "").should eq <<-EOF
      {
    -   height: 3,
    +   height: 7,
        origin: {
          ...
    -     y: 0,
    +     y: 1,
        },
        ...
      }\n
    EOF
  end
end

describe ".print_diff_full" do
  it "has no diff" do
    io = IO::Memory.new
    a = Rectangle.new(Point.new(0, 0), 4, 3)
    b = a
    print_diff_full(a, b, io)
    io.to_s.gsub(/\e.+?m/, "").should eq <<-EOF
    No diffs.
    EOF
  end

  it "has diff" do
    io = IO::Memory.new
    a = Rectangle.new(Point.new(0, 0), 4, 3)
    b = Rectangle.new(Point.new(0, 1), 4, 7)
    print_diff_full(a, b, io)
    io.to_s.gsub(/\e.+?m/, "").should eq <<-EOF
      {
    -   height: 3,
    +   height: 7,
        origin: {
          x: 0,
    -     y: 0,
    +     y: 1,
        },
        width: 4,
      }\n
    EOF
  end
end
