module AssertDiff
  record Option, ommit_consecutive : Bool

  class_property option : Option = Option.new(
    ommit_consecutive: true
  )
end
