# :nodoc:
module AssertDiff
  class Printer
    def initialize(@ommit_consecutive : Bool)
    end

    def print_diff(diff : Diff) : String
      content = dump(diff)
      colorize(content)
    end

    private def dump(diff : Diff, key = nil, indent = "") : String
      indent = indent + "  "
      prefix = key ? "#{indent}#{key}: " : indent

      case diff
      in Same
        mark(' ', key, diff.value, indent)
      in Added
        mark('+', key, diff.value, indent)
      in Deleted
        mark('-', key, diff.value, indent)
      in Changed
        separater = diff.before.is_a?(RawString) ? "\n" : ",\n"
        [
          mark('-', key, diff.before, indent),
          mark('+', key, diff.after, indent),
        ].join(separater)
      in Hash(String, Diff)
        content = if @ommit_consecutive
                    diff.keys.sort!
                      .map { |k| {k, diff[k]} }
                      .grouped_by { |_, v| v.is_a?(Same) }
                      .flat_map { |xs|
                        if xs.first[1].is_a?(Same)
                          "#{indent}  ..."
                        else
                          xs.map { |k, v| dump(v, k, indent) + "," }
                        end
                      }
                      .join("\n")
                  else
                    diff.keys.sort!.join("\n") { |k| dump(diff[k], k, indent) + "," }
                  end
        <<-HASH
        #{prefix}#{"{"}
        #{content}
        #{indent}#{"}"}
        HASH
      in Array(Diff)
        content = if @ommit_consecutive
                    diff
                      .grouped_by &.is_a?(Same)
                      .flat_map { |xs|
                        if xs.first.is_a?(Same)
                          "#{indent}  ..."
                        else
                          xs.map { |s| dump(s, nil, indent) + "," }
                        end
                      }
                      .join("\n")
                  else
                    diff.join("\n") { |s| dump(s, nil, indent) + "," }
                  end
        <<-ARRAY
        #{prefix}[
        #{content}
        #{indent}]
        ARRAY
      in MultilineDiff
        content = diff.join("\n") { |s| dump(s, nil, indent) }
        <<-EOF
        #{indent}#{key}:
        #{indent}  ```
        #{content}
        #{indent}  ```
        EOF
      end
    end

    private def mark(mark : Char, key : String?, value : Raw, indent : String)
      indent = indent.lchop("  ")
      prefix = key ? "#{indent}#{key}: " : indent

      value = case value
              in Bool, Int64, Float64, RawString
                value.to_s
              in String
                "\"#{value}\""
              in Nil
                "nil"
              in Array
                value.to_s # TODO: fix
              in Hash
                head = key ? "#{key}: {" : "{"
                content = <<-EOF
                #{head}
                #{value.join("\n") { |k, v| "  #{k}: #{v}," }}
                }
                EOF
                return content.lines.join("\n") { |s| "#{mark} #{indent}#{s}" }
              end
      "#{mark} #{prefix}#{value}"
    end

    private def colorize(content : String) : String
      content.lines.join("\n") do |line|
        case line
        when .starts_with?("-")
          line.colorize(:red)
        when .starts_with?("+")
          line.colorize(:green)
        when .starts_with?("*")
          line.colorize(:yellow)
        else
          line.colorize(:dark_gray)
        end
      end
    end
  end
end
