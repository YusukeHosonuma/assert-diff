require "colorize"

# :nodoc:
module AssertDiff
  alias Diff = Status |
               Array(Diff) |
               Hash(String, Diff) |
               MultilineDiff

  alias MultilineDiff = Array(Status)

  def self.diff(a : A, b : B) : Diff forall A, B
    if a.is_a?(JSON::Serializable) && b.is_a?(JSON::Serializable) ||
       a.is_a?(JSON::Serializable) && b.is_a?(NamedTuple) ||
       a.is_a?(NamedTuple) && b.is_a?(JSON::Serializable) ||
       a.is_a?(NamedTuple) && b.is_a?(NamedTuple)
      value_diff(
        JSON.parse(a.to_json),
        JSON.parse(b.to_json)
      )
    else
      value_diff(
        JSON.parse(a.__to_h.to_json),
        JSON.parse(b.__to_h.to_json)
      )
    end
  end

  private def self.hash_diff(before : Hash, after : Hash) : Hash(String, Diff)
    result = {} of String => Diff

    before.keys.each do |key|
      x = before[key]
      y = after[key]?
      status = if y.nil?
                 Deleted.new(x.raw)
               else
                 value_diff(x, y)
               end
      result[key] = status
    end

    after.each do |key, y|
      unless before[key]?
        result[key] = Added.new(y.raw)
      end
    end

    result
  end

  private def self.array_diff(xs : Array, ys : Array) : Array(Diff)
    result = [] of Diff

    xs.zip?(ys) do |x, y|
      break if !x || !y
      result << value_diff(x, y)
    end

    case
    when xs.size < ys.size
      result.concat(ys.skip(xs.size).map { |e| Added.new(e.raw) })
    when xs.size > ys.size
      result.concat(xs.skip(ys.size).map { |e| Deleted.new(e.raw) })
    end

    result
  end

  private def self.value_diff(x : JSON::Any, y : JSON::Any) : Diff
    case
    when x == y             then Same.new(x.raw)
    when x.as_h? && y.as_h? then hash_diff(x.as_h, y.as_h)
    when x.as_a? && y.as_a? then array_diff(x.as_a, y.as_a)
    when x.as_s? && y.as_s? then string_diff(x.as_s, y.as_s)
    else                         Changed.new(x.raw, y.raw)
    end
  end

  private def self.string_diff(x : String, y : String) : Status | MultilineDiff
    if x.includes?("\n") || y.includes?("\n")
      multiline_string_diff(x, y)
    else
      if x == y
        Same.new(x)
      else
        Changed.new(x, y)
      end
    end
  end

  private def self.multiline_string_diff(before : String, after : String) : MultilineDiff
    result = MultilineDiff.new

    xs = before.lines
    ys = after.lines

    xs.zip?(ys) do |x, y|
      break if !x || !y

      if x == y
        result << Same.new(RawString.new(x))
      else
        result << Changed.new(RawString.new(x), RawString.new(y))
      end
    end

    case
    when xs.size < ys.size
      result.concat(ys.skip(xs.size).map { |line| Added.new(RawString.new(line)) })
    when xs.size > ys.size
      result.concat(xs.skip(ys.size).map { |line| Deleted.new(RawString.new(line)) })
    end

    result
  end
end
