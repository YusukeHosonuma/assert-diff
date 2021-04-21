require "../spec_helper"

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
        origin: Point {
          ...
    -     y: 0,
    +     y: 1,
        },
        ...
    -   height: 3,
    +   height: 7,
        comment:
          ```
    +     Zero
          One
    -     Two
    +     Two!!
          Three
    -     Four
          ```,
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
    io.to_s.gsub(/\e.+?m/, "").should eq_diff <<-EOF
      Rectangle {
        origin: Point {
          x: 0,
    -     y: 0,
    +     y: 1,
        },
        width: 4,
    -   height: 3,
    +   height: 7,
        comment:
          ```
    +     Zero
          One
    -     Two
    +     Two!!
          Three
    -     Four
          ```,
      }\n
    EOF
  end
end
