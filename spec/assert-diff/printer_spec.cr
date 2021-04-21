require "../spec_helper"
require "json"
require "diff"

private def plain_diff(x, y)
  diff = AssertDiff.diff(x, y)
  printer = AssertDiff::Printer.new(true)
  printer.print_diff(diff).gsub(/\e.+?m/, "")
end

private def plain_diff_full(x, y)
  diff = AssertDiff.diff(x, y)
  printer = AssertDiff::Printer.new(false)
  printer.print_diff(diff).gsub(/\e.+?m/, "")
end

private struct ComplexStruct
  def initialize(
    @int : Int32,
    @float : Float32,
    @bool : Bool,
    @optional : String?,
    @string : String,
    @char : Char,
    @array : Array(Int32),
    @hash : Hash(String, Int32),
    @object : ComplexObject
  )
  end
end

class ComplexObject
  def initialize(
    @int : Int32,
    @float : Float32,
    @bool : Bool,
    @optional : String?,
    @string : String,
    @char : Char,
    @array : Array(Int32),
    @hash : Hash(String, Int32)
  )
  end
end

struct A
  def initialize(@x : Int32)
  end
end

struct B
  def initialize(@x : Int32)
  end
end

describe AssertDiff do
  describe ".print_diff" do
    it "consecutive same are ommitted" do
      before = {
        a:  1,
        b:  2,
        c:  3, # to change
        d:  4, # to delete
        e:  5,
        f:  6,
        xs: [
          1,
          2,
          3,
          4,
          5,
        ],
      }
      after = {
        a:  1,
        b:  2,
        c:  30, # changed
        e:  5,
        f:  6,
        xs: [
          1,
          2,
          30, # changed
          4,
          5,
          6,
        ],
      }
      plain_diff(before, after).should eq <<-DIFF
        {
          ...
      -   c: 3,
      +   c: 30,
      -   d: 4,
          ...
          xs: [
            ...
      -     3,
      +     30,
            ...
      +     6,
          ],
        }
      DIFF
    end

    it "diff basic types" do
      before = BasicTypesStruct.new(
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
      after = BasicTypesStruct.new(
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
        color: Color::Blue
      )
      plain_diff(before, after).should eq_diff <<-DIFF
        BasicTypesStruct {
          array: [
            ...
      -     2,
      +     3,
          ],
      -   bool: true,
      +   bool: false,
      -   char: 'a',
      +   char: 'b',
      -   color: Color::Red,
      +   color: Color::Blue,
          deque: [
            ...
      -     2,
      +     3,
          ],
      -   float: 1.2,
      +   float: 1.3,
          hash: {
            ...
      -     two: 2,
      +     two: 3,
          },
      -   int: 42,
      +   int: 43,
          json: {
            ...
      -     two: "2",
      +     two: "3",
          },
          named_tuple: {
            ...
      -     two: 2,
      +     two: 3,
          },
      -   optional: nil,
      +   optional: "string",
      -   path: "foo/bar/baz.cr",
      +   path: "foo/bar/hoge.cr",
      -   set: Set{1, 2},
      +   set: Set{1, 3},
      -   string: "Hello",
      +   string: "Goodbye",
      -   symbol: :foo,
      +   symbol: :bar,
      -   time: 2016-02-15 10:20:30 +09:00,
      +   time: 2017-02-15 10:20:30 +09:00,
      -   tuple: {1, true},
      +   tuple: {1, false},
      -   uri: http://example.com/,
      +   uri: http://example.com/foo,
        }
      DIFF
      # TODO: Set は內部diffをとってもいい気がする。
    end

    context "object" do
      it "different type" do
        before = [
          A.new(1),
        ]
        after = [
          B.new(1),
        ]
        plain_diff(before, after).should eq <<-DIFF
          [
        -   A {
        -     x: 1,
        -   },
        +   B {
        +     x: 1,
        +   },
          ]
        DIFF
      end

      it "added" do
        before = [] of B
        after = [
          B.new(1),
        ]
        plain_diff(before, after).should eq <<-DIFF
          [
        +   B {
        +     x: 1,
        +   },
          ]
        DIFF
      end

      it "deleted" do
        before = [
          A.new(1),
        ]
        after = [] of A
        plain_diff(before, after).should eq <<-DIFF
          [
        -   A {
        -     x: 1,
        -   },
          ]
        DIFF
      end
    end

    it "diff Hash" do
      before = {
        a:  1,
        b:  2, # to delete
        c:  3, # to change
        xa: {a: 1, b: 1},
        xb: {a: 2, b: 2}, # to delete
        xc: {a: 3, b: 3}, # to change
      }
      after = {
        a:  1,
        c:  4,
        d:  5, # added
        xa: {a: 1, b: 1},
        xc: {a: 3, b: 9}, # changed
        xd: {a: 5, b: 5}, # added
      }
      plain_diff(before, after).should eq <<-DIFF
        {
          ...
      -   b: 2,
      -   c: 3,
      +   c: 4,
      +   d: 5,
          ...
      -   xb: {
      -     a: 2,
      -     b: 2,
      -   },
          xc: {
            ...
      -     b: 3,
      +     b: 9,
          },
      +   xd: {
      +     a: 5,
      +     b: 5,
      +   },
        }
      DIFF
    end

    it "diff array" do
      before = [
        [1, 2, 3],
        {
          x: [1, 2, 3],
        },
      ]
      after = [
        [1, 2, 0, 4],
        {
          x: [1, 2, 0, 4],
          y: [1, 2],
        },
        [1, 2],
      ]
      plain_diff(before, after).should eq_diff <<-DIFF
        [
          [
            ...
      -     3,
      +     0,
      +     4,
          ],
          {
            x: [
              ...
      -       3,
      +       0,
      +       4,
            ],
      +     y: [
      +       1,
      +       2,
      +     ],
          },
      +   [
      +     1,
      +     2,
      +   ],
        ]
      DIFF
    end

    it "diff multiline string" do
      before =
        <<-EOF
        One
        Two
        Three
        Four
        EOF
      after =
        <<-EOF
        Zero
        One
        Two!!
        Three
        EOF

      plain_diff(before, after).should eq <<-DIFF
          ```
      +   Zero
          One
      +   Two!!
      -   Two
          Three
      -   Four
          ```
      DIFF
    end

    it "diff struct and object" do
      before = ComplexStruct.new(
        42,
        1.2,
        true,
        nil,
        "Hello",
        'a',
        [1, 2, 3],
        {"a" => 1, "b" => 2},
        ComplexObject.new(
          42,
          1.2,
          true,
          nil,
          "Hello",
          'a',
          [1, 2, 3],
          {"a" => 1, "b" => 2}
        )
      )
      after = ComplexStruct.new(
        49,
        1.3,
        false,
        "not_nil",
        "Goodbye",
        'b',
        [1, 2, 3, 4],
        {"a" => 1, "b" => 3},
        ComplexObject.new(
          49,
          1.3,
          false,
          "not_nil",
          "Goodbye",
          'b',
          [1, 2, 3, 4],
          {"a" => 1, "b" => 3},
        )
      )
      plain_diff(before, after).should eq_diff <<-DIFF
        ComplexStruct {
          array: [
            ...
      +     4,
          ],
      -   bool: true,
      +   bool: false,
      -   char: 'a',
      +   char: 'b',
      -   float: 1.2,
      +   float: 1.3,
          hash: {
            ...
      -     b: 2,
      +     b: 3,
          },
      -   int: 42,
      +   int: 49,
          object: ComplexObject {
            array: [
              ...
      +       4,
            ],
      -     bool: true,
      +     bool: false,
      -     char: 'a',
      +     char: 'b',
      -     float: 1.2,
      +     float: 1.3,
            hash: {
              ...
      -       b: 2,
      +       b: 3,
            },
      -     int: 42,
      +     int: 49,
      -     optional: nil,
      +     optional: "not_nil",
      -     string: "Hello",
      +     string: "Goodbye",
          },
      -   optional: nil,
      +   optional: "not_nil",
      -   string: "Hello",
      +   string: "Goodbye",
        }
      DIFF
    end
  end

  describe ".print_diff_full" do
    it "full report" do
      before = {
        a:  1,
        b:  2,
        c:  3, # to change
        d:  4, # to delete
        e:  5,
        f:  6,
        xs: [
          1,
          2,
          3,
          4,
          5,
        ],
      }
      after = {
        a:  1,
        b:  2,
        c:  30, # changed
        e:  5,
        f:  6,
        xs: [
          1,
          2,
          30, # changed
          4,
          5,
          6,
        ],
      }
      plain_diff_full(before, after).should eq <<-DIFF
        {
          a: 1,
          b: 2,
      -   c: 3,
      +   c: 30,
      -   d: 4,
          e: 5,
          f: 6,
          xs: [
            1,
            2,
      -     3,
      +     30,
            4,
            5,
      +     6,
          ],
        }
      DIFF
    end
  end
end
