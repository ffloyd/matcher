RSpec.describe Matcher::Mixin do
  subject(:klass) do
    Class.new do
      include Matcher::Mixin

      def method_missing(name, *args, &block)
        send(name, *args, &block) # expose private methods
      end
    end
  end

  describe '#match' do
    subject(:match) { klass.new.match(*pattern) { values } }

    context 'when values match pattern' do
      let(:pattern) { [:ok, String, Integer] }
      let(:values) { [:ok, 'aaa', 22] }

      it 'returns values without modifications' do
        is_expected.to eq values
      end
    end

    context 'when values mismatch pattern' do
      let(:pattern) { [:ok, String, Integer] }
      let(:values) { [:fail, 'aaa', 22] }

      it 'raises error' do
        expect { match }.to raise_error Matcher::Error
      end
    end
  end
end
