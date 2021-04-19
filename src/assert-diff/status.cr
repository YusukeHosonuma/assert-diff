# :nodoc:
module AssertDiff
  alias Status = Same | Added | Deleted | Changed
  record Same, value : Raw
  record Added, value : Raw
  record Deleted, value : Raw
  record Changed, before : Raw, after : Raw

  alias Raw = AnyHash::Type | RawString
end
