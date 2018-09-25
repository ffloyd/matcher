module Matcher
  # core matching mechanism
  module Match
    def self.call(pattern, values)
      pattern.each_with_index do |clause, index|
        return ::Matcher::Error.new unless clause === values[index] # rubocop:disable Style/CaseEquality
      end

      values
    end
  end
end
