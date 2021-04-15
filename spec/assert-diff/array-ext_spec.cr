require "../spec_helper"

describe Array do
  describe ".grouped_by" do
    it "works" do
      ["apple", "grape", "orange", "banana"].grouped_by(&.size)
        .should eq [["apple", "grape"], ["orange", "banana"]]
    end
  end
  describe ".grouped" do
    it "works" do
      ([] of Int32).grouped.should eq ([] of Int32)
      [1, 2, 2, 3].grouped.should eq [[1], [2, 2], [3]]
      [1, 1, 2, 2].grouped.should eq [[1, 1], [2, 2]]
      [1, 2, 3, 4].grouped.should eq [[1], [2], [3], [4]]
    end
  end
end
