require "../spec_helper"

private def test_diff(title, before, after, expected, file = __FILE__, line = __LINE__)
  it "#{title}", file, line do
    diff = AssertDiff.diff(before, after)
    option = AssertDiff::Formatter::Option.new(true)
    report = AssertDiff::SimpleFormatter.new.report(diff, option)
    report.gsub(/\e.+?m/, "").to_s.should eq_diff expected
  end
end

describe AssertDiff::SimpleFormatter do
  describe "#report" do
    test_diff("README",
      Rectangle.new(Point.new(0, 0), 4, 3, "One\nTwo\nThree\nFour"),
      Rectangle.new(Point.new(0, 1), 4, 7, "Zero\nOne\nTwo!!\nThree"),
      <<-EOF
      .origin.y: - 0
                 + 1
      .height: - 3
               + 7
      .comment: - "One\\nTwo\\nThree\\nFour"
                + "Zero\\nOne\\nTwo!!\\nThree"
      EOF
    )

    context "array" do
      test_diff("change and add",
        [1, 2],
        [1, 9, 3],
        <<-EOF
        [1]: - 2
             + 9
        [2]: + 3
        EOF
      )

      test_diff("array delete element",
        [1, 2],
        [1],
        <<-EOF
        [1]: - 2
        EOF
      )
    end

    context "hash" do
      test_diff("change and add",
        {
          a: 1,
          b: 2,
        },
        {
          a: 1,
          b: 9, # changed
          c: 3,
        },
        <<-EOF
        .b: - 2
            + 9
        .c: + 3
        EOF
      )

      test_diff("deleted",
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

    test_diff("multi-line string",
      "One\nTwo\nThree\nFour",
      "Zero\nOne\nTwo!!\nThree",
      <<-EOF
      - "One\\nTwo\\nThree\\nFour"
      + "Zero\\nOne\\nTwo!!\\nThree"
      EOF
    )

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

    test_diff("basic types",
      BasicTypesStruct.before,
      BasicTypesStruct.after,
      <<-EOF
      .int: - 42
            + 43
      .float: - 1.2
              + 1.3
      .bool: - true
             + false
      .optional: - nil
                 + "string"
      .string: - "Hello"
               + "Goodbye"
      .path: - "foo/bar/baz.cr"
             + "foo/bar/hoge.cr"
      .symbol: - :foo
               + :bar
      .char: - 'a'
             + 'b'
      .array[1]: - 2
                 + 3
      .deque[1]: - 2
                 + 3
      .set: - Set{1, 2}
            + Set{1, 3}
      .hash.two: - 2
                 + 3
      .tuple: - {1, true}
              + {1, false}
      .named_tuple.two: - 2
                        + 3
      .time: - 2016-02-15 10:20:30 +09:00
             + 2017-02-15 10:20:30 +09:00
      .uri: - http://example.com/
            + http://example.com/foo
      .json.two: - "2"
                 + "3"
      .color: - Color::Red
              + Color::Blue
      EOF
    )
  end
end
