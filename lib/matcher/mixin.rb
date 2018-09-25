module Matcher
  # enable matching helpers in your class
  module Mixin
    private

    def ok(*args)
      [:ok, *args]
    end

    def err(*args)
      [:err, *args]
    end

    def match(*pattern, &values_proc)
      result = Matcher::Match.call(pattern, Array(values_proc.call))

      case result
      when Matcher::Error then raise result
      else result
      end
    end

    def case_match(values, pattern_map = {})
      values     = Array(values)
      else_proc  = pattern_map.delete(:else)
      mismatches = []

      pattern_map.each do |pattern, proc|
        result = Matcher::Match.call(pattern, values)

        if result.is_a? Matcher::Error
          mismatches << result
        else
          return proc.call(result)
        end
      end

      return else_proc.call(values) if else_proc

      raise Matcher::CaseError.new(mismatches)
    end
  end
end
