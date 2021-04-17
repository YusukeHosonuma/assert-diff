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

      printer = Printer.new(@ommit_consecutive)
      diff = printer.print_diff(AssertDiff.diff(@expected_value, actual_value)).split("\n")

      original_message + "\n" +
        <<-EOF
          #{"diff:".colorize(:dark_gray)} #{diff.[0]}
      #{diff.[1..].join("\n") { |s| " " * 10 + s }}
      EOF
    end

    forward_missing_to @original_expectation
  end
end
