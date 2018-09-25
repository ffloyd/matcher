module Matcher
  # core matching mechanism
  module Match
    class << self
      def call(pattern, values)
        pattern.each_with_index do |clause, index|
          next  if clause == :_
          break if clause == :*

          if clause.is_a? Array
            return Matcher::Error.new if call(clause, values[index]).is_a?(Matcher::Error)
          else
            return Matcher::Error.new unless clause === values[index] # rubocop:disable Style/CaseEquality
          end
        end

        values
      end
    end
  end
end
