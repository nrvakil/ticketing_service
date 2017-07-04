RSpec.describe Ticket, type: :model do
  let(:created_ticket) { FactoryGirl.create(:ticket, subject: 'ticket 1', content: 'ticket1') }
  let(:update_params) do
    {
      id: created_ticket.id, subject: 'updated ticket', content: 'u1'
    }
  end

  describe '.validations' do
    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:user_id) }
    it { should validate_inclusion_of(:status).in_array(TICKET_STATUS_LIST) }
  end

  describe '.create' do
    subject { created_ticket }

    specify { expect(subject.id).not_to be_nil }
    specify { expect(subject.subject).to eq 'ticket 1' }
  end

  describe '.update' do
    subject do
      created_ticket.update_attributes! update_params
      created_ticket
    end

    specify { expect(subject.subject).to eq 'updated ticket' }
    specify { expect(subject.content).to eq 'u1' }
  end
end
