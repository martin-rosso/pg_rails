# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  discarded_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  profiles               :integer          default([]), not null, is an Array
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

FactoryBot.define do
  factory :user, class: 'User' do
    nombre { nil }
    apellido { nil }
    email { Faker::Internet.email }
    password { "password#{rand(99_999)}" }
    confirmed_at { Faker::Date.backward }

    transient do
      account { nil }
    end

    after(:create) do |model, context|
      if context.account
        model.user_accounts.create!(account: context.account)
      end
    end

    trait :orphan do
      orphan { true }
    end

    trait :admin do
      developer do
        pg_deprecation 'trait "admin"', 'use trait "developer" instead',
                       deprecator: PgEngine.deprecator
        true
      end
    end

    trait :developer do
      developer { true }
    end

    trait :owner do
      after(:create) do |model|
        model.user_accounts.create!(profiles: [:account__owner])
      end
    end

    trait :guest do
      after(:create) do |model|
        model.user_accounts.create(profiles: [])
      end
    end

    trait :disabled do
      after(:create) do |model|
        model.user_accounts.update_all(membership_status: :ms_disabled)
      end
    end
  end
end
