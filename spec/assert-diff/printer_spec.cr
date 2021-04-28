require "../spec_helper"
require "json"
require "diff"

# TODO: formatter_spec.cr で賄えてそうなら削除する

private def plain_diff(x, y)
  diff = AssertDiff.diff(x, y)
  printer = AssertDiff::DefaultFormatter.new
  printer.option = AssertDiff::Option.new(true)
  printer.report(diff).gsub(/\e.+?m/, "")
end

private def plain_diff_full(x, y)
  diff = AssertDiff.diff(x, y)
  printer = AssertDiff::DefaultFormatter.new
  printer.option = AssertDiff::Option.new(false)
  printer.report(diff).gsub(/\e.+?m/, "")
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

private struct A
  def initialize(@x : Int32, @y : Int32)
  end
end

private struct B
  def initialize(@x : Int32, @y : Int32)
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

    # it "diff basic types" do
    #   before = BasicTypesStruct.before
    #   after = BasicTypesStruct.after
    #   plain_diff(before, after).should eq_diff <<-DIFF
    #     BasicTypesStruct {
    #   -   int: 42,
    #   +   int: 43,
    #   -   float: 1.2,
    #   +   float: 1.3,
    #   -   bool: true,
    #   +   bool: false,
    #   -   optional: nil,
    #   +   optional: "string",
    #   -   string: "Hello",
    #   +   string: "Goodbye",
    #   -   path: "foo/bar/baz.cr",
    #   +   path: "foo/bar/hoge.cr",
    #   -   symbol: :foo,
    #   +   symbol: :bar,
    #   -   char: 'a',
    #   +   char: 'b',
    #       array: [
    #         ...
    #   -     2,
    #   +     3,
    #       ],
    #       deque: [
    #         ...
    #   -     2,
    #   +     3,
    #       ],
    #   -   set: Set{1, 2},
    #   +   set: Set{1, 3},
    #       hash: {
    #         ...
    #   -     two: 2,
    #   +     two: 3,
    #       },
    #   -   tuple: {1, true},
    #   +   tuple: {1, false},
    #       named_tuple: {
    #         ...
    #   -     two: 2,
    #   +     two: 3,
    #       },
    #   -   time: 2016-02-15 10:20:30 +09:00,
    #   +   time: 2017-02-15 10:20:30 +09:00,
    #   -   uri: http://example.com/,
    #   +   uri: http://example.com/foo,
    #       json: {
    #         ...
    #   -     two: "2",
    #   +     two: "3",
    #       },
    #   -   color: Color::Red,
    #   +   color: Color::Blue,
    #     }
    #   DIFF
    #   # TODO: Set は內部diffをとってもいい気がする。
    # end

    context "object" do
      it "different type" do
        before = [
          A.new(1, 2),
        ]
        after = [
          B.new(1, 2),
        ]
        plain_diff(before, after).should eq <<-DIFF
          [
        -   A {
        -     x: 1,
        -     y: 2,
        -   },
        +   B {
        +     x: 1,
        +     y: 2,
        +   },
          ]
        DIFF
      end

      it "added" do
        before = [] of B
        after = [
          B.new(1, 2),
        ]
        plain_diff(before, after).should eq <<-DIFF
          [
        +   B {
        +     x: 1,
        +     y: 2,
        +   },
          ]
        DIFF
      end

      it "deleted" do
        before = [
          A.new(1, 2),
        ]
        after = [] of A
        plain_diff(before, after).should eq <<-DIFF
          [
        -   A {
        -     x: 1,
        -     y: 2,
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
      -   Two
      +   Two!!
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
      -   int: 42,
      +   int: 49,
      -   float: 1.2,
      +   float: 1.3,
      -   bool: true,
      +   bool: false,
      -   optional: nil,
      +   optional: "not_nil",
      -   string: "Hello",
      +   string: "Goodbye",
      -   char: 'a',
      +   char: 'b',
          array: [
            ...
      +     4,
          ],
          hash: {
            ...
      -     b: 2,
      +     b: 3,
          },
          object: ComplexObject {
      -     int: 42,
      +     int: 49,
      -     float: 1.2,
      +     float: 1.3,
      -     bool: true,
      +     bool: false,
      -     optional: nil,
      +     optional: "not_nil",
      -     string: "Hello",
      +     string: "Goodbye",
      -     char: 'a',
      +     char: 'b',
            array: [
              ...
      +       4,
            ],
            hash: {
              ...
      -       b: 2,
      +       b: 3,
            },
          },
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
