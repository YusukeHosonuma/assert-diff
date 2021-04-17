# The same as `.eq`, but print readable diff report if actual not equals *value* (`!=`).
#
# ```
# x = {a: 1, b: 2, c: 3}
# y = {a: 1, b: 2, c: 0}
# x.should eq_diff y
# # =>
# # Expected: {a: 1, b: 2, c: 0}
# #      got: {a: 1, b: 2, c: 3}
# #     diff:   {
# #             ...
# #         -   c: 3,
# #         +   c: 0,
# #           }
# ```
def eq_diff(value)
  AssertDiff::EqualDiffExpectation.new(value, true)
end

# The same as `.eq_diff`, but this print full diff report.
#
# ```
# x = {a: 1, b: 2, c: 3}
# y = {a: 1, b: 2, c: 0}
# x.should eq_diff_full y
# # =>
# # Expected: {a: 1, b: 2, c: 0}
# #      got: {a: 1, b: 2, c: 3}
# #     diff:   {
# #             a: 1,
# #             b: 2,
# #         -   c: 3,
# #         +   c: 0,
# #           }
# ```
def eq_diff_full(value)
  AssertDiff::EqualDiffExpectation.new(value, false)
end

# The same as `.eq_diff`, but this can be used independently.
#
# ```
# assert_diff(x, y)
# ```
def assert_diff(before : A, after : B, file = __FILE__, line = __LINE__) forall A, B
  assert_diff_internal(before, after, file, line, true)
end

# The same as `.eq_diff_full`, but this can be used independently.
#
# ```
# assert_diff_full(x, y)
# ```
def assert_diff_full(before : A, after : B, file = __FILE__, line = __LINE__) forall A, B
  assert_diff_internal(before, after, file, line, false)
end

private def assert_diff_internal(before, after, file, line, ommit_consecutive)
  expectation = AssertDiff::EqualDiffExpectation.new(after, ommit_consecutive)
  unless expectation.match before
    failure_message = expectation.failure_message(before)
    fail(failure_message, file, line)
  end
end
