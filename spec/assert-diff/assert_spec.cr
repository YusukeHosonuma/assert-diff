require "../spec_helper"

EXPECTED = {a: 1, b: 2, c: 3}
ACTUAL   = {a: 1, b: 2, c: 0}

EXPECTED_MESSAGE = <<-EOF
Expected: {a: 1, b: 2, c: 3}
     got: {a: 1, b: 2, c: 0}
    diff:   {
              ...
          -   c: 3,
          +   c: 0,
            }
EOF

EXPECTED_MESSAGE_FULL = <<-EOF
Expected: {a: 1, b: 2, c: 3}
     got: {a: 1, b: 2, c: 0}
    diff:   {
              a: 1,
              b: 2,
          -   c: 3,
          +   c: 0,
            }
EOF

describe AssertDiff do
  describe "expectations" do
    it ".eq_diff" do
      begin
        ACTUAL.should eq_diff EXPECTED
      rescue ex : Spec::AssertionFailed
        ex.line.should eq 31
        ex.file.should eq __FILE__
        strip_escape_code(ex.message).should eq EXPECTED_MESSAGE
      else
        fail "Nothing was raised"
      end
    end

    it ".eq_diff_full" do
      begin
        ACTUAL.should eq_diff_full EXPECTED
      rescue ex : Spec::AssertionFailed
        ex.line.should eq 43
        ex.file.should eq __FILE__
        strip_escape_code(ex.message).should eq EXPECTED_MESSAGE_FULL
      else
        fail "Nothing was raised"
      end
    end
  end

  describe "assertions" do
    it ".assert_diff" do
      begin
        assert_diff(EXPECTED, ACTUAL)
      rescue ex : Spec::AssertionFailed
        ex.line.should eq 57
        ex.file.should eq __FILE__
        strip_escape_code(ex.message).should eq EXPECTED_MESSAGE
      else
        fail "Nothing was raised"
      end
    end

    it ".assert_diff_full" do
      begin
        assert_diff_full(EXPECTED, ACTUAL)
      rescue ex : Spec::AssertionFailed
        ex.line.should eq 69
        ex.file.should eq __FILE__
        strip_escape_code(ex.message).should eq EXPECTED_MESSAGE_FULL
      else
        fail "Nothing was raised"
      end
    end
  end

  describe ".formatter" do
    it "use SimpleFormatter" do
      begin
        AssertDiff.formatter = AssertDiff::SimpleFormatter.new
        assert_diff(EXPECTED, ACTUAL)
      rescue ex : Spec::AssertionFailed
        strip_escape_code(ex.message).should eq <<-EOF
        Expected: {a: 1, b: 2, c: 3}
             got: {a: 1, b: 2, c: 0}
            diff: .c: - 3
                      + 0
        EOF
      else
        fail "Nothing was raised"
      end
    end
  end
end

private def strip_escape_code(message)
  message.not_nil!.gsub(/\e.+?m/, "")
end
