require "../spec_helper"

describe "asssertions" do
  before = {
    a: "1",
    b: "2", # to delete
    c: "3", # to change
    x: {
      a: 1,
      b: true, # to delete
      c: nil,  # to change
    },
    y: [
      1,
      2,
    ],
  }
  after = {
    a: "1",
    c: "4",
    d: "5", # added
    x: {
      a: 1,
      c: 1.2,   # changed
      d: false, # added
    },
    y: [
      1,
      3,
    ],
  }

  it ".assert_diff" do
    begin
      assert_diff(before, after) # line number is important!!
    rescue ex : Spec::AssertionFailed
      ex.file.should eq __FILE__
      ex.line.should eq 35
      ex.message.not_nil!.gsub(/\e.+?m/, "").should eq <<-EOF
      Expected: {a: "1", c: "4", d: "5", x: {a: 1, c: 1.2, d: false}, y: [1, 3]}
           got: {a: "1", b: "2", c: "3", x: {a: 1, b: true, c: nil}, y: [1, 2]}
          diff:   {
                    ...
                -   b: "2",
                -   c: "3",
                +   c: "4",
                +   d: "5",
                    x: {
                      ...
                -     b: true,
                -     c: nil,
                +     c: 1.2,
                +     d: false,
                    },
                    y: [
                      ...
                -     2,
                +     3,
                    ],
                  }
      EOF
    end
  end

  it ".assert_diff_full" do
    begin
      assert_diff_full(before, after) # line number is important!!
    rescue ex : Spec::AssertionFailed
      ex.file.should eq __FILE__
      ex.line.should eq 67
      ex.message.not_nil!.gsub(/\e.+?m/, "").should eq <<-EOF
      Expected: {a: "1", c: "4", d: "5", x: {a: 1, c: 1.2, d: false}, y: [1, 3]}
           got: {a: "1", b: "2", c: "3", x: {a: 1, b: true, c: nil}, y: [1, 2]}
          diff:   {
                    a: "1",
                -   b: "2",
                -   c: "3",
                +   c: "4",
                +   d: "5",
                    x: {
                      a: 1,
                -     b: true,
                -     c: nil,
                +     c: 1.2,
                +     d: false,
                    },
                    y: [
                      1,
                -     2,
                +     3,
                    ],
                  }
      EOF
    end
  end
end

describe "eq_diff" do
  it "works" do
    x = { a: 1, b: 2 }
    y = { a: 1, b: 9 }
    begin
      x.should eq_diff y
    rescue ex : Spec::AssertionFailed
      ex.line.should eq 103
      ex.message.not_nil!.gsub(/\e.+?m/, "").should eq <<-EOF
      Expected: {a: 1, b: 9}
           got: {a: 1, b: 2}
          diff:   {
                    ...
                -   b: 2,
                +   b: 9,
                  }
      EOF
    else
      fail "Nothing was raised"
    end
  end
end
