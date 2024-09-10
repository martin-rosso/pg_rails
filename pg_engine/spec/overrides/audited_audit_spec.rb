require 'rails_helper'

describe 'Audited::Audit' do
  subject do
    create :categoria_de_cosa
  end

  it 'creates the audits' do
    expect { subject }.to change(Audited::Audit, :count).by(1)
  end

  it 'assigns the tenant to audits' do
    subject
    expect(Audited::Audit.last.account).to eq ActsAsTenant.current_tenant
  end
end
