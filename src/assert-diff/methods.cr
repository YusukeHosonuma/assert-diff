require "colorize"

# Print diff to *io*.
# ```
# a = Rectangle.new(Point.new(0, 0), 4, 3)
# b = Rectangle.new(Point.new(0, 1), 4, 7)
# print_diff(a, b)
# # =>
# #   {
# # -   height: 3,
# # +   height: 7,
# #     origin: {
# #       ...
# # -     y: 0,
# # +     y: 1,
# #     },
# #     ...
# #   }
# ```
def print_diff(before, after, io : IO = STDOUT)
  print_diff_to_io(before, after, true, io)
end

# Print diff to *io*.
# ```
# a = Rectangle.new(Point.new(0, 0), 4, 3)
# b = Rectangle.new(Point.new(0, 1), 4, 7)
# print_diff_full(a, b)
# # =>
# # {
# # -   height: 3,
# # +   height: 7,
# #     origin: {
# #       x: 0,
# # -     y: 0,
# # +     y: 1,
# #     },
# #     width: 4,
# # }
# ```
def print_diff_full(before, after, io : IO = STDOUT)
  print_diff_to_io(before, after, false, io)
end

private def print_diff_to_io(before, after, ommit_consecutive, io : IO = STDOUT)
  if before == after
    io.print("No diffs.".colorize(:yellow))
  else
    printer = AssertDiff::Printer.new(ommit_consecutive)
    diff = AssertDiff.diff(before, after)
    message = printer.print_diff(diff)
    io.puts(message)
  end
end
