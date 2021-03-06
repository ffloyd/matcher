RSpec.shared_examples 'success match' do |pattern, values|
  it "successfully matches #{pattern.inspect} on #{values.inspect} and returns original values" do
    expect(described_class.call(pattern, values)).to eq values
  end
end

RSpec.shared_examples 'failure match' do |pattern, values|
  it "not matches #{pattern.inspect} on #{values.inspect} and returns error" do
    expect(described_class.call(pattern, values)).to be_a Matcher::Error
  end
end

RSpec.describe Matcher::Match do
  include_examples 'success match', [String], ['aaa']
  include_examples 'success match', [Integer], [22]
  include_examples 'success match', [1..3],   [3]
  include_examples 'success match', [:ok],    [:ok]

  include_examples 'failure match', [String], [1]
  include_examples 'failure match', [Integer], [22.22]
  include_examples 'failure match', [1..3],   [4]
  include_examples 'failure match', [:ok],    [:error]

  include_examples 'success match', [String, Integer], ['aaa', 22]
  include_examples 'success match', [1...3, 1..3],     [2, 3]

  include_examples 'failure match', [String, Integer], [:aaa, 22]
  include_examples 'failure match', [1...3, 1..3],     [3, 3]

  include_examples 'success match', [:_], [1]
  include_examples 'success match', [:_], [nil]
  include_examples 'success match', [:_], [:_]

  include_examples 'success match', [:_, 10], [:_, 10]

  include_examples 'success match', [:*], [1, 10]
  include_examples 'success match', [:*], [1, 10, '100']
  include_examples 'success match', [:*], []

  include_examples 'success match', [:ok, :*], [:ok]
  include_examples 'success match', [:ok, :*], [:ok, 1]

  include_examples 'failure match', [:ok, :*], [:err, 22]
  include_examples 'failure match', [:ok, :*], [:err, :ok]

  include_examples 'success match', [:ok, [:ok]], [:ok, [:ok]]
  include_examples 'success match', [:ok, [:err, [:ok, [:err], [:ok]]]], [:ok, [:err, [:ok, [:err], [:ok]]]]
  include_examples 'success match', [:ok, [String, String, :*]], [:ok, ['a', 'b']]

  include_examples 'failure match', [:ok, [:ok, 'aaa']],  [:ok, [:err, 'bbb']]
  include_examples 'failure match', [:ok, [:ok, String]], [:ok, [:ok, :symbol]]
end
