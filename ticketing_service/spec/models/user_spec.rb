RSpec.describe User, type: :model do
  let(:created_user) { FactoryGirl.create(:user, name: 'user 1', email: 'user1@g.com') }
  let(:update_params) do
    {
      id: created_user.id, name: 'updated user', email: 'u1@g.com'
    }
  end

  # describe '.validations' do
  #   it { should validate_presence_of(:name) }
  #   it { should validate_presence_of(:email) }
  #   it { should validate_inclusion_of(:status).in_array(USER_STATUS_LIST) }
  # end

  describe '.create' do
    subject { created_user }

    specify { expect(subject.id).not_to be_nil }
    specify { expect(subject.name).to eq 'user 1' }
  end

  describe '.update' do
    subject do
      created_user.update_attributes! update_params
      created_user
    end

    specify { expect(subject.name).to eq 'updated user' }
    specify { expect(subject.email).to eq 'u1@g.com' }
  end
end
