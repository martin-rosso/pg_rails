module PgEngine
  module ActiveJobExtensions
    def serialize
      super.merge(
        'app_name' => ::Current.app_name,
        'user_id' => ::Current.user&.id
      )
    end

    def deserialize(job_data)
      ::Current.app_name = job_data.delete('app_name')&.to_sym
      ::Current.user = User.find(job_data.delete('user_id')) if job_data['user_id'].present?

      super
    end
  end
end
