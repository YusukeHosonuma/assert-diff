# assert-diff

Assert equals with readable diff report.

![screenshot](https://github.com/YusukeHosonuma/assert-diff/raw/main/image/screenshot.png)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     assert-diff:
       github: YusukeHosonuma/assert-diff
   ```

2. Run `shards install`

## Example

Use in specs:

```crystal
require "assert-diff"

struct Rectangle
  def initialize(@origin : Point, @width : Int32, @height : Int32)
  end
end

struct Point
  def initialize(@x : Int32, @y : Int32)
  end
end

describe Rectangle do
  describe "example" do
    it "failed" do
      a = Rectangle.new(Point.new(0, 0), 4, 3)
      b = Rectangle.new(Point.new(0, 1), 4, 7)
      assert_diff(a, b)
    end
  end
end

# Expected: {"origin" => {"x" => 0, "y" => 1}, "width" => 4, "height" => 7}
#      got: {"origin" => {"x" => 0, "y" => 0}, "width" => 4, "height" => 3}
#     diff:   {
#           -   height: 3,
#           +   height: 7,
#               origin: {
#                 ...
#           -     y: 0,
#           +     y: 1,
#               }
#               ...
#             }
```

Use to output:

```crystal
print_diff(a, b)
print_diff_full(a, b)
```

## Contributing

I don't think it can be used for edge cases.  
Issues and PRs are welcome.

1. Fork it (<https://github.com/YusukeHosonuma/assert-diff/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Yusuke Hosonuma](https://github.com/YusukeHosonuma) - creator and maintainer
