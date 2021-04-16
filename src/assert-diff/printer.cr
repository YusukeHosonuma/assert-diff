# :nodoc:
module AssertDiff
  class Printer
    def initialize(@ommit_consecutive : Bool)
    end

    def print_diff(diff : Diff) : String
      content = dump(diff).rchop(",")
      colorize(content)
    end

    private def dump(status : Diff, key = nil, indent = "") : String
      prefix = if key
                 "#{indent}#{key}: "
               else
                 "#{indent}"
               end

      case status
      in Same
        mark(' ', key, status.value, indent)
      in Added
        mark('+', key, status.value, indent)
      in Deleted
        mark('-', key, status.value, indent)
      in Changed
        separater = status.before.is_a?(RawString) ? "\n" : ",\n"
        [
          mark('-', key, status.before, indent),
          mark('+', key, status.after, indent),
        ].join(separater)
      in Hash(String, Diff)
        content = if @ommit_consecutive
                    status.keys.sort
                      .map { |k| {k, status[k]} }
                      .grouped_by { |_, v| v.is_a?(Same) }
                      .flat_map { |xs|
                        if xs.first[1].is_a?(Same)
                          "  #{indent}  ..."
                        else
                          xs.map { |k, v| dump(v, k, indent + "  ") + "," }
                        end
                      }
                      .join("\n")
                  else
                    status.keys.sort.map { |k| dump(status[k], k, indent + "  ") + "," }.join("\n")
                  end
        <<-HASH
          #{prefix}#{"{"}
        #{content}
          #{indent}#{"}"}
        HASH
      in Array(Diff)
        content = if @ommit_consecutive
                    status
                      .grouped_by &.is_a?(Same)
                      .flat_map { |xs|
                        if xs.first.is_a?(Same)
                          "  #{indent}  ..."
                        else
                          xs.map { |s| dump(s, nil, indent + "  ") + "," }
                        end
                      }
                      .join("\n")
                  else
                    status.map { |s| dump(s, nil, indent + "  ") + "," }.join("\n")
                  end
        <<-ARRAY
          #{prefix}[
        #{content}
          #{indent}]
        ARRAY
      in MultilineDiff
        content = status
          .map { |s|
            dump(s, nil, indent + "  ")
          }
          .join("\n")
        <<-EOF
          #{indent}#{key}:
          #{indent}  ```
        #{content}
          #{indent}  ```
        EOF
      end
    end

    private def mark(mark : Char, key : String?, value : Raw, indent : String)
      prefix = key ? "#{indent}#{key}: " : "#{indent}"

      value = case value
              when .nil?
                "nil"
              when .is_a?(RawString)
                value.to_s
              when .is_a?(String)
                "\"#{value}\""
              when .is_a?(Hash)
                head = key ? "#{key}: {" : "{"
                content = <<-EOF
                #{head}
                #{value.map { |k, v| "  #{k}: #{v}," }.join("\n")}
                }
                EOF
                return content.split("\n").map { |s| "#{mark} #{indent}#{s}" }.join("\n")
              else
                value.to_s
              end

      "#{mark} #{prefix}#{value}"
    end

    private def indent_tail(string : String, indent : Int) : String
      return string unless string.includes?("\n")
      lines = string.split("\n")
      head = lines[0]
      tail = lines[1..]
      head + "\n" + tail.map { |s| "#{" " * indent}#{s}" }.join("\n")
    end

    private def colorize(lines : String) : String
      lines.split("\n").map do |line|
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
      end.join("\n")
    end
  end
end
