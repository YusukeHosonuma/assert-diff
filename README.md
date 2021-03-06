# assert-diff
[![CI](https://github.com/YusukeHosonuma/assert-diff/actions/workflows/main.yaml/badge.svg)](https://github.com/YusukeHosonuma/assert-diff/actions/workflows/main.yaml)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://yusukehosonuma.github.io/assert-diff/)
[![GitHub release](https://img.shields.io/github/release/YusukeHosonuma/assert-diff.svg)](https://github.com/YusukeHosonuma/assert-diff/releases)

Assert equals with readable diff report.

![screenshot](https://github.com/YusukeHosonuma/assert-diff/raw/main/image/screenshot.png)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   development_dependencies:
     assert-diff:
       github: YusukeHosonuma/assert-diff
       branch: main
   ```

2. Run `shards install`

## Example

Use in specs:

```crystal
require "assert-diff"

describe "README.md" do
  it "example" do
    expected = Rectangle.new(Point.new(0, 1), 4, 7, "One\nTwo\nThree\nFour")
    actual = Rectangle.new(Point.new(0, 0), 4, 3, "Zero\nOne\nTwo!!\nThree")

    actual.should eq_diff expected # or use `eq_full_diff`
  end
end
```

or use `assert_diff` and `assert_diff_full`.

```crystal
assert_diff(before, after)
assert_diff_full(before, after)
```

Use to output:

```crystal
print_diff(before, after)
print_diff_full(before, after)
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
