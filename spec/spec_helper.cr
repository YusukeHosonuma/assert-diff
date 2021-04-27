require "spec"
require "../src/assert-diff"
require "./asset"

Spec.before_each do
  AssertDiff.formatter = AssertDiff::DefaultFormatter.new
end
