module PgEngine
  module ActiveJobExtensions
    def serialize
      super.merge(
        'app_name' => ::Current.app_name
      )
    end

    def deserialize(job_data)
      ::Current.app_name = job_data.delete('app_name')

      super
    end
  end
end
