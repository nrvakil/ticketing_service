RSpec.describe Agents::Assignment do
  before :each do
    User.destroy_all
    Agent.destroy_all

    @lazy_agent = FactoryGirl.create(:agent)
    @busy_agent = FactoryGirl.create(:agent)
    @assigned_ticket = FactoryGirl.create(:ticket, agent: @busy_agent)
  end

  describe '.laziest_agent' do
    subject { Agents::Assignment.new.laziest_agent }

    context 'with at least one approved agent' do
      specify { expect(subject.id).not_to be_nil }
      specify { expect(subject.id).to eq @lazy_agent.id }
    end

    context 'with no approved agents' do
      before :each do
        Agent.update_all status: States.agent.banned
      end

      specify { expect(subject).to be_nil }
    end
  end

  describe '.laziest_agent!' do
    subject { Agents::Assignment.new.laziest_agent! }

    context 'with at least one approved agent' do
      specify { expect(subject.id).not_to be_nil }
      specify { expect(subject.id).to eq @lazy_agent.id }
    end

    context 'with no approved agents' do
      before :each do
        Agent.update_all status: States.agent.banned
      end

      specify { expect { subject }.to raise_error Exceptions::MissingAgents }
    end
  end

  describe '.laziest_agent_id' do
    subject { Agents::Assignment.new.laziest_agent_id }

    context 'with at least one approved agent' do
      specify { expect(subject).not_to be_nil }
      specify { expect(subject).to eq @lazy_agent.id }
    end

    context 'with no approved agents' do
      before :each do
        Agent.update_all status: States.agent.banned
      end

      specify { expect(subject).to be_nil }
    end
  end

  describe '.laziest_agent_id!' do
    subject { Agents::Assignment.new.laziest_agent_id! }

    context 'with at least one approved agent' do
      specify { expect(subject).not_to be_nil }
      specify { expect(subject).to eq @lazy_agent.id }
    end

    context 'with no approved agents' do
      before :each do
        Agent.update_all status: States.agent.banned
      end

      specify { expect { subject }.to raise_error Exceptions::MissingAgents }
    end
  end

  describe '.reassign' do
    subject do
      @busy_agent.update_attributes! status: States.agent.banned
      Agents::Assignment.new(agent: @assigned_ticket.agent).reassign

      Ticket.find(@assigned_ticket.id).agent_id
    end

    context 'with at least one approved agent' do
      specify { expect(subject).not_to be_nil }
      specify { expect(subject).to eq @lazy_agent.id }
    end

    context 'with no approved agents' do
      before :each do
        Agent.update_all status: States.agent.banned
      end

      specify { expect(subject).to be_nil }
    end
  end
end
