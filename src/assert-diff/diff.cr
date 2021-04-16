require "colorize"

# :nodoc:
module AssertDiff
  alias MultilineDiff = Array(Status)
  alias Diff = Status | Array(Diff) | Hash(String, Diff) | MultilineDiff
  alias Status = Same | Added | Deleted | Changed
  alias Raw = JSON::Any::Type | RawString

  struct RawString
    def initialize(@raw : String)
    end

    def to_s
      @raw
    end
  end

  struct Same
    property value : Raw

    def initialize(@value : Raw)
    end
  end

  struct Added
    property value : Raw

    def initialize(@value : Raw)
    end
  end

  struct Deleted
    property value : Raw

    def initialize(@value : Raw)
    end
  end

  struct Changed
    property before : Raw
    property after : Raw

    def initialize(@before : Raw, @after : Raw)
    end
  end

  def self.diff(a : A, b : B) : Diff forall A, B
    if a.is_a?(JSON::Serializable) && b.is_a?(JSON::Serializable) ||
       a.is_a?(JSON::Serializable) && b.is_a?(NamedTuple) ||
       a.is_a?(NamedTuple) && b.is_a?(JSON::Serializable) ||
       a.is_a?(NamedTuple) && b.is_a?(NamedTuple)
      json_diff(
        JSON.parse(a.to_json),
        JSON.parse(b.to_json)
      )
    else
      json_diff(
        JSON.parse(a.__to_h.to_json),
        JSON.parse(b.__to_h.to_json)
      )
    end
  end

  private def self.json_diff(before, after) : Diff
    case
    when before.as_h? && after.as_h?
      hash_diff(before.as_h, after.as_h)
    when before.as_a? && after.as_a?
      array_diff(before.as_a, after.as_a)
    else
      raise "not reachable"
    end
  end

  private def self.hash_diff(before : Hash, after : Hash) : Hash(String, Diff)
    result = {} of String => Diff

    before.keys.each do |key|
      x = before[key]
      y = after[key]?
      status = case
               when y.nil?             then Deleted.new(x.raw)
               when x == y             then Same.new(x.raw)
               when x.as_h? && y.as_h? then hash_diff(x.as_h, y.as_h)
               when x.as_a? && y.as_a? then array_diff(x.as_a, y.as_a)
               when x.as_s? && y.as_s? then string_diff(x.as_s, y.as_s)
               else                         Changed.new(x.raw, y.raw)
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

  private def self.string_diff(before, after) : Status | MultilineDiff
    if before.includes?("\n") || after.includes?("\n")
      multiline_diff(before, after)
    else
      if before == after
        Same.new(before)
      else
        Changed.new(before, after)
      end
    end
  end

  private def self.multiline_diff(before, after) : MultilineDiff
    xs = before.split("\n")
    ys = after.split("\n")

    result = MultilineDiff.new

    xs.zip(ys) do |x, y|
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

  private def self.array_diff(before, after) : Array(Diff)
    result = [] of Diff

    before.zip?(after) do |x, y|
      break if !x || !y

      case
      when x == y
        result << Same.new(x.raw)
      when x.as_h? && y.as_h?
        result << hash_diff(x.as_h, y.as_h)
      when x.as_a? && y.as_a?
        result << array_diff(x.as_a, y.as_a)
      else
        result << Changed.new(x.raw, y.raw)
      end
    end

    case
    when before.size < after.size
      result.concat(after.skip(before.size).map { |e| Added.new(e.raw) })
    when before.size > after.size
      result.concat(before.skip(after.size).map { |e| Deleted.new(e.raw) })
    end

    result
  end
end
