# frozen_string_literal: true

# generado con pg_rails

FactoryBot.define do
  factory :account do
    plan { Account.plan.values.sample }
    nombre { Faker::Lorem.sentence }

    trait :with_owner do
      after(:create) do |model|
        ActsAsTenant.with_tenant(model) do
          create :user, :owner
        end
      end
    end
  end
end
