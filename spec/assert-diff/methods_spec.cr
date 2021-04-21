require "../spec_helper"

struct Rectangle
  def initialize(@origin : Point, @width : Int32, @height : Int32, @comment : String)
  end
end

struct Point
  def initialize(@x : Int32, @y : Int32)
  end
end

describe "README.md" do
  pending "example" do
    expected = Rectangle.new(Point.new(0, 1), 4, 7, "One\nTwo\nThree\nFour")
    actual = Rectangle.new(Point.new(0, 0), 4, 3, "Zero\nOne\nTwo!!\nThree")

    actual.should eq_diff expected # or use `eq_full_diff`
  end
end

describe ".print_diff" do
  it "has no diff" do
    io = IO::Memory.new
    a = Rectangle.new(Point.new(0, 0), 4, 3, "One\nTwo\nThree\nFour")
    b = a
    print_diff(a, b, io)
    io.to_s.gsub(/\e.+?m/, "").should eq <<-EOF
    No diffs.
    EOF
  end

  it "has diff" do
    io = IO::Memory.new
    a = Rectangle.new(Point.new(0, 0), 4, 3, "One\nTwo\nThree\nFour")
    b = Rectangle.new(Point.new(0, 1), 4, 7, "Zero\nOne\nTwo!!\nThree")
    print_diff(a, b, io)
    io.to_s.gsub(/\e.+?m/, "").should eq_diff <<-EOF
      Rectangle {
        comment:
          ```
    +     Zero
          One
    -     Two
    +     Two!!
          Three
    -     Four
          ```,
    -   height: 3,
    +   height: 7,
        origin: Point {
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
    a = Rectangle.new(Point.new(0, 0), 4, 3, "One\nTwo\nThree\nFour")
    b = a
    print_diff_full(a, b, io)
    io.to_s.gsub(/\e.+?m/, "").should eq <<-EOF
    No diffs.
    EOF
  end

  it "has diff" do
    io = IO::Memory.new
    a = Rectangle.new(Point.new(0, 0), 4, 3, "One\nTwo\nThree\nFour")
    b = Rectangle.new(Point.new(0, 1), 4, 7, "Zero\nOne\nTwo!!\nThree")
    print_diff_full(a, b, io)
    io.to_s.gsub(/\e.+?m/, "").should eq <<-EOF
      Rectangle {
        comment:
          ```
    +     Zero
          One
    -     Two
    +     Two!!
          Three
    -     Four
          ```,
    -   height: 3,
    +   height: 7,
        origin: Point {
          x: 0,
    -     y: 0,
    +     y: 1,
        },
        width: 4,
      }\n
    EOF
  end
end
