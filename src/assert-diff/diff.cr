require "colorize"
require "diff"

# :nodoc:
module AssertDiff
  alias Raw = AnyHash::Type | RawString

  alias Status = Same | Added | Deleted | Changed
  record Same, value : Raw
  record Added, value : Raw
  record Deleted, value : Raw
  record Changed, before : Raw, after : Raw

  alias Diff = Status |
               Array(Diff) |
               Hash(String, Diff) |
               MultilineDiff |
               ObjectDiff

  record MultilineDiff,
    before : String,
    after : String,
    diffs : Array(Status)

  alias PropertyDiff = KeyValue(String, Diff)

  struct ObjectDiff
    getter typename, properties

    def initialize(@typename : String, @properties : Array(PropertyDiff))
    end
  end

  def self.diff(a : A, b : B) : Diff forall A, B
    any_diff(a.__to_json_any, b.__to_json_any)
  end

  private def self.any_diff(x : AnyHash, y : AnyHash) : Diff
    return Same.new(x.raw) if x == y

    x, y = x.raw, y.raw
    case {x, y}
    when {AnyObject, AnyObject} then object_diff(x, y)
    when {Hash, Hash}           then hash_diff(x, y)
    when {Array, Array}         then array_diff(x, y)
    when {String, String}       then string_diff(x, y)
    else                             Changed.new(x, y)
    end
  end

  private def self.object_diff(x : AnyObject, y : AnyObject)
    return Changed.new(x, y) if x.typename != y.typename

    ObjectDiff.new(
      x.typename,
      x.properties.zip(y.properties).map do |px, py|
        PropertyDiff.new(px.key, any_diff(px.value, py.value))
      end
    )
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
    result = [] of Status

    # Note:
    # diff ????????? Deleted -> Added ????????????????????????????????????????????????????????????
    ::Diff.diff(after.lines, before.lines).each do |chunk|
      next unless data = chunk.data

      diff_type = case chunk
                  when .append? then Deleted
                  when .delete? then Added
                  else               Same
                  end
      string = RawString.new(data.join("\n"))
      result << diff_type.new(string)
    end

    MultilineDiff.new(before, after, result)
  end
end
