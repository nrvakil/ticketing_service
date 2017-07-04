RSpec.describe Agents::Assignment do
  before :each do
    @agent1 = FactoryGirl.create(:agent)
    @agent2 = FactoryGirl.create(:agent)
    @ticket1 = FactoryGirl.create(:ticket)
  end

  describe '.laziest_agent' do
    subject { Agents::Assignment.new.laziest_agent }

    specify { expect(subject.id).not_to be_nil }
    specify { expect(subject.id).to eq @agent1.id }
  end
end
