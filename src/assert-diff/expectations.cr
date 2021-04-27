require "spec"

# :nodoc:
module AssertDiff
  struct EqualDiffExpectation(T)
    @original_expectation : Spec::EqualExpectation(T)

    def initialize(@expected_value : T, @ommit_consecutive : Bool)
      @original_expectation = Spec::EqualExpectation.new(@expected_value)
    end

    def failure_message(actual_value)
      original_message = @original_expectation.failure_message(actual_value)

      diff = AssertDiff.diff(@expected_value, actual_value)

      report = AssertDiff.formatter.report(diff, Formatter::Option.new(@ommit_consecutive))
      lines = report.lines

      original_message + "\n" +
        <<-EOF
          #{"diff:".colorize(:dark_gray)} #{lines[0]}
      #{lines[1..].join("\n") { |s| " " * 10 + s }}
      EOF
    end

    forward_missing_to @original_expectation
  end
end
