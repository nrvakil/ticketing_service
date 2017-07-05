RSpec.describe JsonWebToken do
  let(:payload) { { something: 'some payload!' } }

  describe '#encode' do
    context 'with payload' do
      subject { JsonWebToken.encode(payload) }

      specify { expect(subject).not_to be_nil }
      specify { expect(JsonWebToken.decode(subject).first).to have_key 'something' }
    end

    context 'without payload' do
      subject { JsonWebToken.encode({}) }

      specify { expect(subject).not_to be_nil }
      specify { expect(JsonWebToken.decode(subject).first).to be_empty }
    end
  end
end
