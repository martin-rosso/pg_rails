require 'rails_helper'

describe AccountPolicy do
  subject do
    described_class.new(user, account)
  end

  let(:account) { ActsAsTenant.current_tenant }
  let(:user) { create :user }

  it do
    expect(subject).to permit(:show)
  end

  it do
    user.user_accounts.first.update(membership_status: :disabled)
    expect(subject).to permit(:show)
  end
end
