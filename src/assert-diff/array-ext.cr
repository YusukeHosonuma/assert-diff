# :nodoc:
class Array
  def grouped_by(&block : T -> U) forall T, U
    result = [] of Array(T)

    each do |e|
      if result.size == 0
        result << [e]
      else
        k1 = yield result.last.last
        k2 = yield e

        if k1 == k2
          result.last << e
        else
          result << [e]
        end
      end
    end

    result
  end

  def grouped
    grouped_by { |e| e }
  end
end
