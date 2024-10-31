module PgEngine
  module AccountsHelper
    def show_profiles_for(user_account, profile_group)
      aux = profile_group[:options].select { |opt| user_account.profiles.include?(opt.first) }
      aux = aux.map(&:last).map { |pr| t(pr, scope: 'profile_member') }.join(', ').html_safe
      aux.presence || 'No'
    end
  end
end
