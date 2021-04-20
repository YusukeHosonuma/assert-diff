require "colorize"

# :nodoc:
module AssertDiff
  alias Diff = Status |
               Array(Diff) |
               Hash(String, Diff) |
               MultilineDiff |
               ObjectDiff

  alias MultilineDiff = Array(Status)

  struct ObjectDiff
    getter typename : String # TODO:
    getter properties : Hash(String, Diff)

    def initialize(@typename : String, @properties : Hash(String, Diff))
    end
  end

  def self.diff(a : A, b : B) : Diff forall A, B
    any_diff(a.__to_json_any, b.__to_json_any)
  end

  private def self.any_diff(x : AnyHash, y : AnyHash) : Diff
    case
    when x == y             then Same.new(x.raw)
    when x.as_h? && y.as_h? then hash_diff(x.as_h, y.as_h)
    when x.as_a? && y.as_a? then array_diff(x.as_a, y.as_a)
    when x.as_s? && y.as_s? then string_diff(x.as_s, y.as_s)
    when x.as_o? && y.as_o?
      properties_diff = hash_diff(x.as_o.properties, y.as_o.properties)
      ObjectDiff.new(x.as_o.typename, properties_diff)
    else
      Changed.new(x.raw, y.raw)
    end
  end

  private def self.hash_diff(before : Hash, after : Hash) : Hash(String, Diff)
    result = {} of String => Diff

    before.each_key do |key|
      x = before[key]
      y = after[key]?
      status = if y.nil?
                 Deleted.new(x.raw)
               else
                 any_diff(x, y)
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
      result << any_diff(x, y)
    end

    case
    when xs.size < ys.size
      result.concat(ys.skip(xs.size).map { |e| Added.new(e.raw) })
    when xs.size > ys.size
      result.concat(xs.skip(ys.size).map { |e| Deleted.new(e.raw) })
    end

    result
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
