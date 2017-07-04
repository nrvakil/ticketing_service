RSpec.describe Tickets::Crud do
  let(:now) { Time.now }
  let(:user) { FactoryGirl.create(:user) }

  let(:created_ticket) { FactoryGirl.create(:ticket) }

  let(:create_params) do
    {
      subject: 'ttt1', content: '/sdsf/', user_id: user.id
    }
  end

  let(:update_params) do
    {
      id: created_ticket.id, subject: 'ttt2', content: '/aa/bb',
      user_id: user.id
    }
  end

  before :each do
    @agent1 = FactoryGirl.create(:agent)
    @agent2 = FactoryGirl.create(:agent)
    @ticket1 = FactoryGirl.create(:ticket)
  end

  describe '.create' do
    subject { Tickets::Crud.new(create_params).create }

    specify { expect(subject.id).not_to be_nil }

    context 'with auto assign agent' do
      specify { expect(subject.agent_id).not_to be_nil }
    end

    specify do
      expect(subject.subject).to eq create_params[:subject]
      expect(subject.content).to eq create_params[:content]
    end
  end

  describe '.update' do
    subject { Tickets::Crud.new(update_params).update }

    specify { expect(subject).to be_truthy }
  end
end
