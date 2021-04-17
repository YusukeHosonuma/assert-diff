require "../spec_helper"
require "json"

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

private struct BasicTypes
  def initialize(
    @int : Int32,
    @float : Float32,
    @bool : Bool,
    @optional : String?,
    @string : String,
    @multiline_string : String,
    @char : Char
  )
  end
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
      before = BasicTypes.new(
        42,
        1.2,
        true,
        nil,
        "Hello",
        "Apple\nOrange\nBanana",
        'a',
      )
      after = BasicTypes.new(
        49,
        1.3,
        false,
        "not nil",
        "Goodbye",
        "Apple\nGrape\nBanana",
        'b',
      )
      plain_diff(before, after).should eq <<-DIFF
        {
      -   bool: true,
      +   bool: false,
      -   char: "a",
      +   char: "b",
      -   float: 1.2,
      +   float: 1.3,
      -   int: 42,
      +   int: 49,
          multiline_string:
            ```
            Apple
      -     Orange
      +     Grape
            Banana
            ```,
      -   optional: nil,
      +   optional: "not nil",
      -   string: "Hello",
      +   string: "Goodbye",
        }
      DIFF
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
      before = [
        "One\nTwo\nThree",
        {x: "One\nTwo\nThree"},
      ]
      after = [
        "One\nTwo\nFour",
        {x: "One\nTwo\nFour"},
      ]

      plain_diff(before, after).should eq <<-DIFF
        [
            ```
            One
            Two
      -     Three
      +     Four
            ```,
          {
            x:
              ```
              One
              Two
      -       Three
      +       Four
              ```,
          },
        ]
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
      plain_diff(before, after).should eq <<-DIFF
        {
          array: [
            ...
      +     4,
          ],
      -   bool: true,
      +   bool: false,
      -   char: "a",
      +   char: "b",
      -   float: 1.2,
      +   float: 1.3,
          hash: {
            ...
      -     b: 2,
      +     b: 3,
          },
      -   int: 42,
      +   int: 49,
          object: {
            array: [
              ...
      +       4,
            ],
      -     bool: true,
      +     bool: false,
      -     char: "a",
      +     char: "b",
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
