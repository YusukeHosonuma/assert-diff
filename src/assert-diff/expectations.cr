require "spec"

# :nodoc:
module AssertDiff
  struct EqualDiffExpectation(T)
    @original_expectation : Spec::EqualExpectation(T)

    def initialize(@expected_value : T, @option : Option? = nil)
      @original_expectation = Spec::EqualExpectation.new(@expected_value)
    end

    def failure_message(actual_value)
      original_message = @original_expectation.failure_message(actual_value)

      diff = AssertDiff.diff(@expected_value, actual_value)
      report = formatter.report(diff).lines

      <<-EOF
      #{original_message}
          #{"diff:".colorize(:dark_gray)} #{report[0]}
      #{report[1..].join("\n") { |s| " " * 10 + s }}
      EOF
    end

    forward_missing_to @original_expectation

    private def formatter
      formatter = AssertDiff.formatter
      formatter.option = @option || AssertDiff.option
      formatter
    end
  end
end
