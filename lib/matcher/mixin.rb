module Matcher
  # enable matching helpers in your class
  module Mixin
    private

    def match(*pattern, &values_proc)
      result = Matcher::Match.call(pattern, Array(values_proc.call))

      case result
      when Matcher::Error then raise result
      else result
      end
    end
  end
end
