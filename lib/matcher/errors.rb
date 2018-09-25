module Matcher
  class Error < StandardError
  end

  class CaseError < Error
    def initialize(matcher_errors)
      @matcher_errors = matcher_errors
    end
  end
end
