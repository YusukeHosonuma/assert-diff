require "json"

# Assert equals with diff report.
#
# Consecutive no-changed are ommited like "...".
# Use `.assert_diff_full` if you need full-report.
#
# ```
# struct Rectangle
#   def initialize(@origin : Point, @width : Int32, @height : Int32)
#   end
# end
#
# struct Point
#   def initialize(@x : Int32, @y : Int32)
#   end
# end
#
# describe Rectangle do
#   describe "example" do
#     it "failed" do
#       a = Rectangle.new(Point.new(0, 0), 4, 3)
#       b = Rectangle.new(Point.new(0, 1), 4, 7)
#       assert_diff(a, b)
#     end
#   end
# end
#
# # Expected: {"origin" => {"x" => 0, "y" => 1}, "width" => 4, "height" => 7}
# #      got: {"origin" => {"x" => 0, "y" => 0}, "width" => 4, "height" => 3}
# #     diff:   {
# #           -   height: 3,
# #           +   height: 7,
# #               origin: {
# #                 ...
# #           -     y: 0,
# #           +     y: 1,
# #               }
# #               ...
# #             }
# ```
def assert_diff(before : A, after : B, file = __FILE__, line = __LINE__) forall A, B
  begin
    before.should eq after
  rescue ex : Spec::AssertionFailed
    throw_assertion(ex, before, after, file, line, true)
  end
end

# Assert equals with full diff report.
#
# ```
# struct Rectangle
#   def initialize(@origin : Point, @width : Int32, @height : Int32)
#   end
# end
#
# struct Point
#   def initialize(@x : Int32, @y : Int32)
#   end
# end
#
# describe Rectangle do
#   describe "example" do
#     it "failed" do
#       a = Rectangle.new(Point.new(0, 0), 4, 3)
#       b = Rectangle.new(Point.new(0, 1), 4, 7)
#       assert_diff(a, b)
#     end
#   end
# end
# # Expected: {"origin" => {"x" => 0, "y" => 1}, "width" => 4, "height" => 7}
# #      got: {"origin" => {"x" => 0, "y" => 0}, "width" => 4, "height" => 3}
# #     diff:   {
# #           -   height: 3,
# #           +   height: 7,
# #               origin: {
# #                 x: 0,
# #           -     y: 0,
# #           +     y: 1,
# #               },
# #               width: 4,
# #             }
# ```
def assert_diff_full(before : A, after : B, file = __FILE__, line = __LINE__) forall A, B
  begin
    before.should eq after
  rescue ex : Spec::AssertionFailed
    throw_assertion(ex, before, after, file, line, false)
  end
end

private def throw_assertion(exception, before, after, file, line, ommit_consecutive = true)
  printer = AssertDiff::Printer.new(ommit_consecutive)
  diff = printer.print_diff(AssertDiff.diff(before, after)).split("\n")

  diff_report = <<-EOF
  #{diff.[0]}
  #{diff.[1..].map { |s| " " * 10 + s }.join("\n")}
  EOF

  message = <<-DIFF
  #{exception.message.not_nil!}
      #{"diff:".colorize(:dark_gray).to_s} #{diff_report}
  DIFF
  raise Spec::AssertionFailed.new(message.to_s, file, line)
end
