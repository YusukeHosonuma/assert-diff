require "../spec_helper"

describe "README.md" do
  it "example" do
    expected = Rectangle.new(Point.new(0, 1), 4, 7, "One\nTwo\nThree\nFour")
    actual = Rectangle.new(Point.new(0, 0), 4, 3, "Zero\nOne\nTwo!!\nThree")

    actual.should eq_diff expected # or use `eq_full_diff`
  end
end
