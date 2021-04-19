require "../spec_helper"

describe AssertDiff do
  describe ".diff" do
    context "Array" do
      it "changed/added" do
        before = [
          1,
          2,
        ]
        after = [
          1,
          9, # changed
          4, # added
        ]
        expected = [
          same(1),
          changed(2, 9),
          added(4),
        ]
        AssertDiff.diff(before, after).should eq expected
      end

      it "deleted" do
        before = [
          1,
          2, # to delete
        ]
        after = [
          1,
        ]
        expected = [
          same(1),
          deleted(2),
        ]
        AssertDiff.diff(before, after).should eq expected
      end

      it "nested array" do
        before = [
          [
            10,
            20, # to change
          ],
        ]
        after = [
          [
            10,
            90, # changed
            30, # added
          ],
        ]
        expected = [
          [
            same(10),
            changed(20, 90),
            added(30),
          ],
        ]
        AssertDiff.diff(before, after).should eq expected
      end
    end
    context "Hash" do
      it "changed" do
        before = {
          a: 1,
          b: 2,
          c: 3,
        }
        after = {
          a: 1,
          c: 9, # changed
          d: 5,
        }
        expected = {
          "a" => same(1),
          "b" => deleted(2),
          "c" => changed(3, 9),
          "d" => added(5),
        }
        AssertDiff.diff(before.to_h, after.to_h).should eq expected
      end
      it "added, removed" do
        before = {
          a: {x: 1, y: 2},
          b: {x: 3, y: 4}, # deleted
        }
        after = {
          a: {x: 1, y: 2},
          c: {x: 5, y: 6}, # added
        }
        expected = {
          "a" => AssertDiff::Same.new({"x" => AnyHash.new(Int64.new(1)), "y" => AnyHash.new(Int64.new(2))}),
          "b" => AssertDiff::Deleted.new({"x" => AnyHash.new(Int64.new(3)), "y" => AnyHash.new(Int64.new(4))}),
          "c" => AssertDiff::Added.new({"x" => AnyHash.new(Int64.new(5)), "y" => AnyHash.new(Int64.new(6))}),
        }
        AssertDiff.diff(before.to_h, after.to_h).should eq expected
      end
      it "nested" do
        before = {
          x: {
            a: 10,
            b: 20, # to delete
            c: 30,
          },
        }
        after = {
          x: {
            a: 10,
            c: 90, # changed
            d: 50,
          },
        }
        expected = {
          "x" => {
            "a" => same(10),
            "b" => deleted(20),
            "c" => changed(30, 90),
            "d" => added(50),
          },
        }
        AssertDiff.diff(before.to_h, after.to_h).should eq expected
      end
    end
  end
end

private def same(x : Int32)
  AssertDiff::Same.new(Int64.new(x))
end

private def deleted(x : Int32)
  AssertDiff::Deleted.new(Int64.new(x))
end

private def changed(x : Int32, y : Int32)
  AssertDiff::Changed.new(Int64.new(x), Int64.new(y))
end

private def added(x : Int32)
  AssertDiff::Added.new(Int64.new(x))
end
