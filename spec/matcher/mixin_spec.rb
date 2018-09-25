RSpec.describe Matcher::Mixin do
  subject(:ctx) { klass.new }

  let(:klass) do
    Class.new do
      include Matcher::Mixin

      def method_missing(name, *args, &block)
        send(name, *args, &block) # expose private methods
      end
    end
  end

  describe '#match' do
    context 'when values match pattern' do
      subject do
        ctx.match(:ok, String, Integer) { values }
      end

      let(:values) { [:ok, 'aaa', 22] }

      it 'returns values without modifications' do
        is_expected.to eq values
      end
    end

    context 'when values mismatch pattern' do
      subject(:match) do
        ctx.match(:ok, String, Integer) { [:err, 'aaa', 22] }
      end

      it do
        expect { match }.to raise_error Matcher::Error
      end
    end
  end

  describe '#case_match' do
    let(:callback) do
      double.tap do |dbl|
        allow(dbl).to receive(:call).and_return(callback_result)
      end
    end

    let(:callback_result) { double }

    context 'when values match on 2nd pattern' do
      subject do
        ctx.case_match [:ok, 13.0],
          [:ok, Integer] => proc {},
          [:ok, Float]   => callback
      end

      it 'returns result from callback' do
        is_expected.to eq callback_result
      end
    end

    context 'when values mismatch and no else given' do
      subject(:case_match) do
        ctx.case_match [:ok, '13.0'],
          [:ok, Integer] => proc {},
          [:ok, Float]   => proc {}
      end

      it do
        expect { case_match }.to raise_error Matcher::CaseError
      end
    end

    context 'when values mismatch and else given' do
      subject(:case_match) do
        ctx.case_match [:ok, '13.0'],
          [:ok, Integer] => proc {},
          [:ok, Float]   => proc {},
          else: callback
      end

      it 'returns result from callback' do
        is_expected.to eq callback_result
      end
    end
  end

  describe '#ok' do
    it 'prepends arguments with :ok and returns array' do
      expect(ctx.ok(1, 2, 3)).to eq [:ok, 1, 2, 3]
    end
  end

  describe '#err' do
    it 'prepends arguments with :err and returns array' do
      expect(ctx.err(1, 2, 3)).to eq [:err, 1, 2, 3]
    end
  end
end
