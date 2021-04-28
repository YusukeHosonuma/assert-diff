require "../spec_helper"

private def assert_default_formatter(title, before, after, option, expected, file = __FILE__, line = __LINE__)
  it "#{title}", file, line do
    diff = AssertDiff.diff(before, after)
    formatter = AssertDiff::DefaultFormatter.new
    formatter.option = option
    plain_report = formatter.report(diff).gsub(/\e.+?m/, "")
    plain_report.to_s.should eq_diff expected
  end
end

private def assert_simple_formatter(title, before, after, expected, file = __FILE__, line = __LINE__)
  it "#{title}", file, line do
    diff = AssertDiff.diff(before, after)
    report = AssertDiff::SimpleFormatter.new.report(diff)
    report.gsub(/\e.+?m/, "").to_s.should eq_diff expected
  end
end

describe AssertDiff::DefaultFormatter do
  context "Option#ommit_consecutive" do
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

    assert_default_formatter("true",
      before,
      after,
      AssertDiff::Option.new(true),
      <<-DIFF
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
    )

    assert_default_formatter("false",
      before,
      after,
      AssertDiff::Option.new(false),
      <<-DIFF
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
    )
  end

  assert_default_formatter("basic types",
    BasicTypesStruct.before,
    BasicTypesStruct.after,
    AssertDiff::Option.new(true),
    <<-DIFF
      BasicTypesStruct {
    -   int: 42,
    +   int: 43,
    -   float: 1.2,
    +   float: 1.3,
    -   bool: true,
    +   bool: false,
    -   optional: nil,
    +   optional: "string",
    -   string: "Hello",
    +   string: "Goodbye",
    -   path: "foo/bar/baz.cr",
    +   path: "foo/bar/hoge.cr",
    -   symbol: :foo,
    +   symbol: :bar,
    -   char: 'a',
    +   char: 'b',
        array: [
          ...
    -     2,
    +     3,
        ],
        deque: [
          ...
    -     2,
    +     3,
        ],
    -   set: Set{1, 2},
    +   set: Set{1, 3},
        hash: {
          ...
    -     two: 2,
    +     two: 3,
        },
    -   tuple: {1, true},
    +   tuple: {1, false},
        named_tuple: {
          ...
    -     two: 2,
    +     two: 3,
        },
    -   time: 2016-02-15 10:20:30 +09:00,
    +   time: 2017-02-15 10:20:30 +09:00,
    -   uri: http://example.com/,
    +   uri: http://example.com/foo,
        json: {
          ...
    -     two: "2",
    +     two: "3",
        },
    -   color: Color::Red,
    +   color: Color::Blue,
        array_of_hash: [
    +     {
    +       one: 1,
    +       two: 2,
    +     },
        ],
        array_of_array: [
    +     [
    +       1,
    +       2,
    +     ],
        ],
        array_of_object: [
    +     A {
    +       x: 1,
    +       y: 2,
    +     },
        ],
      }
    DIFF
    # TODO: Set は內部diffをとってもいい気がする。
  )

  assert_default_formatter("Hash",
    {
      a:  1,
      b:  2, # to delete
      c:  3, # to change
      xa: {a: 1, b: 1},
      xb: {a: 2, b: 2}, # to delete
      xc: {a: 3, b: 3}, # to change
    },
    {
      a:  1,
      c:  4,
      d:  5, # added
      xa: {a: 1, b: 1},
      xc: {a: 3, b: 9}, # changed
      xd: {a: 5, b: 5}, # added
    },
    AssertDiff::Option.new(true),
    <<-DIFF
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
  )

  assert_default_formatter("Array",
    [
      [1, 2, 3],
      {
        x: [1, 2, 3],
      },
    ],
    [
      [1, 2, 0, 4],
      {
        x: [1, 2, 0, 4],
        y: [1, 2],
      },
      [1, 2],
    ],
    AssertDiff::Option.new(true),
    <<-DIFF
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
  )

  assert_default_formatter("Multi-line string",
    (
      <<-EOF
      One
      Two
      Three
      Four
      EOF
    ),
    (
      <<-EOF
      Zero
      One
      Two!!
      Three
      EOF
    ),
    AssertDiff::Option.new(true),
    <<-DIFF
        ```
    +   Zero
        One
    -   Two
    +   Two!!
        Three
    -   Four
        ```
    DIFF
  )
end

describe AssertDiff::SimpleFormatter do
  describe "#report" do
    assert_simple_formatter("README",
      Rectangle.new(Point.new(0, 0), 4, 3, "One\nTwo\nThree\nFour"),
      Rectangle.new(Point.new(0, 1), 4, 7, "Zero\nOne\nTwo!!\nThree"),
      <<-EOF
      .origin.y: - 0
                 + 1
      .height:   - 3
                 + 7
      .comment:  - "One\\nTwo\\nThree\\nFour"
                 + "Zero\\nOne\\nTwo!!\\nThree"
      EOF
    )

    context "array" do
      assert_simple_formatter("change and add",
        [1, 2],
        [1, 9, 3],
        <<-EOF
        [1]: - 2
             + 9
        [2]: + 3
        EOF
      )

      assert_simple_formatter("array delete element",
        [1, 2],
        [1],
        <<-EOF
        [1]: - 2
        EOF
      )
    end

    context "hash" do
      assert_simple_formatter("change and add",
        {
          a: 1,
          b: 2,
        },
        {
          a: 1,
          b: 9, # changed
          c: 3,
          d: {a: 1, b: 2},
        },
        <<-EOF
        .b: - 2
            + 9
        .c: + 3
        .d: + {a: 1, b: 2}
        EOF
      )

      assert_simple_formatter("deleted",
        {
          a: 1,
          b: 2, # to delete
        },
        {
          a: 1,
        },
        <<-EOF
        .b: - 2
        EOF
      )
    end

    assert_simple_formatter("multi-line string",
      "One\nTwo\nThree\nFour",
      "Zero\nOne\nTwo!!\nThree",
      <<-EOF
      - "One\\nTwo\\nThree\\nFour"
      + "Zero\\nOne\\nTwo!!\\nThree"
      EOF
    )

    assert_simple_formatter("basic types",
      BasicTypesStruct.before,
      BasicTypesStruct.after,
      <<-EOF
      .int:                - 42
                           + 43
      .float:              - 1.2
                           + 1.3
      .bool:               - true
                           + false
      .optional:           - nil
                           + "string"
      .string:             - "Hello"
                           + "Goodbye"
      .path:               - "foo/bar/baz.cr"
                           + "foo/bar/hoge.cr"
      .symbol:             - :foo
                           + :bar
      .char:               - 'a'
                           + 'b'
      .array[1]:           - 2
                           + 3
      .deque[1]:           - 2
                           + 3
      .set:                - Set{1, 2}
                           + Set{1, 3}
      .hash.two:           - 2
                           + 3
      .tuple:              - {1, true}
                           + {1, false}
      .named_tuple.two:    - 2
                           + 3
      .time:               - 2016-02-15 10:20:30 +09:00
                           + 2017-02-15 10:20:30 +09:00
      .uri:                - http://example.com/
                           + http://example.com/foo
      .json.two:           - "2"
                           + "3"
      .color:              - Color::Red
                           + Color::Blue
      .array_of_hash[0]:   + {one: 1, two: 2}
      .array_of_array[0]:  + [1, 2]
      .array_of_object[0]: + A { x: 1, y: 2 }
      EOF
    )
  end

  it "colorize" do
    before = {
      a: 1,
      b: [1],
      c: [1, 2],
    }
    after = {
      a: 2,      # changed
      b: [1, 2], # added
      c: [1],    # deleted
    }
    diff = AssertDiff.diff(before, after)
    report = AssertDiff::SimpleFormatter.new.report(diff)
    report.to_s.should eq_diff <<-DIFF
    #{".a:    ".colorize(:white)}#{"- 1".colorize(:red)}
           #{"+ 2".colorize(:green)}
    #{".b[1]: ".colorize(:white)}#{"+ 2".colorize(:green)}
    #{".c[1]: ".colorize(:white)}#{"- 2".colorize(:red)}
    DIFF
  end
end
