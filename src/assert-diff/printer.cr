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
      indent += "  "

      case diff
      in Same
        mark(' ', key, diff.value, indent)
      in Added
        mark('+', key, diff.value, indent)
      in Deleted
        mark('-', key, diff.value, indent)
      in Changed
        mark_changed(diff, key, indent)
      in Hash(String, Diff)
        dump_hash(diff, key, indent)
      in Array(Diff)
        dump_array(diff, key, indent)
      in MultilineDiff
        dump_multiline(diff, key, indent)
      in ObjectDiff
        dump_properties(diff.properties, key, indent, diff.typename)
      end
    end

    private def dump_hash(diff : Hash(String, Diff), key : String?, indent : String) : String
      properties = [] of PropertyDiff

      diff.keys.sort!.each do |k|
        properties << PropertyDiff.new(k, diff[k])
      end

      dump_properties(properties, key, indent)
    end

    private def dump_array(diff : Array(Diff), key : String?, indent : String) : String
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
      prefix = key ? "#{indent}#{key}: " : indent

      <<-ARRAY
      #{prefix}[
      #{content}
      #{indent}]
      ARRAY
    end

    private def dump_multiline(diff : MultilineDiff, key : String?, indent : String) : String
      content = diff.join("\n") { |s| dump(s, nil, indent) }

      body = <<-EOF
      #{indent}  ```
      #{content}
      #{indent}  ```
      EOF

      prefix = key ? "#{indent}#{key}:\n" : ""
      prefix + body
    end

    private def mark_changed(changed : Changed, key : String?, indent : String) : String
      separater = changed.before.is_a?(RawString) ? "\n" : ",\n"
      [
        mark('-', key, changed.before, indent),
        mark('+', key, changed.after, indent),
      ].join(separater)
    end

    private def mark(mark : Char, key : String?, value : Raw, indent : String)
      indent = indent.lchop("  ")
      content = (key ? "#{key}: " : "") + dump_raw(value)
      content.lines.join("\n") do |line|
        "#{mark} #{indent}#{line}"
      end
    end

    private def dump_raw(value : Raw)
      case value
      in Bool, Int32, Int64, Float32, Float64, AnyTuple, Time, URI, RawString, AnyEnum
        value.to_s
      in Char
        "'#{value}'"
      in String
        "\"#{value}\""
      in Symbol
        ":#{value}"
      in Nil
        "nil"
      in Array
        <<-EOF
        [
        #{value.join("\n") { |e| "  #{e}," }}
        ]
        EOF
      in Set
        "Set{" + value.join(", ") + "}"
      in Hash
        <<-EOF
        {
        #{value.join("\n") { |k, v| "  #{k}: #{v}," }}
        }
        EOF
      in AnyObject
        <<-EOF
        #{value.typename} {
        #{value.properties.join("\n") { |p| "  #{p.key}: #{p.value}," }}
        }
        EOF
      end
    end

    private def dump_properties(diff : Array(PropertyDiff), key : String?, indent : String, typename : String? = nil) : String
      content = if @ommit_consecutive
                  diff
                    .grouped_by { |p| p.value.is_a?(Same) }
                    .flat_map { |xs|
                      if xs.first.value.is_a?(Same)
                        "#{indent}  ..."
                      else
                        xs.map { |p| dump(p.value, p.key, indent) + "," }
                      end
                    }
                    .join("\n")
                else
                  diff.join("\n") { |p| dump(p.value, p.key, indent) + "," }
                end
      prefix = key ? "#{indent}#{key}: " : indent
      prefix += "#{typename.colorize.mode(:bold)} " if typename

      <<-HASH
      #{prefix}#{"{".colorize(:dark_gray)}
      #{content}
      #{indent}#{"}"}
      HASH
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
