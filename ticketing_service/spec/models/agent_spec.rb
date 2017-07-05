RSpec.describe Agent, type: :model do
  let(:created_agent) do
    FactoryGirl.create(:agent, name: 'agent 1', email: 'agent1@g.com', password: 'pwd')
  end

  let(:update_params) do
    { id: created_agent.id, name: 'updated agent', email: 'u1@g.com' }
  end

  describe '.validations' do
    subject { FactoryGirl.create(:agent) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_inclusion_of(:status).in_array(States.agent_states) }
  end

  describe '.create' do
    subject { created_agent }

    specify { expect(subject.id).not_to be_nil }
    specify { expect(subject.name).to eq 'agent 1' }
  end

  describe '.update' do
    subject do
      created_agent.update_attributes! update_params
      created_agent
    end

    specify { expect(subject.name).to eq 'updated agent' }
    specify { expect(subject.email).to eq 'u1@g.com' }
  end
end
