# :nodoc:
module AssertDiff
  struct RawString
    def initialize(@raw : String)
    end

    def to_s(io : IO) : Nil
      io << @raw
    end
  end
end
