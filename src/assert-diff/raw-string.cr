# :nodoc:
module AssertDiff
  struct RawString
    def initialize(@raw : String)
    end

    def to_s
      @raw
    end
  end
end
