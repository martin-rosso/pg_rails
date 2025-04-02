# MonkeyPatch para que las direct uploads usen el service
# local. Si se usa S3 es complicado, porque hay que setear
# la CORS config.
ActiveStorage::DirectUploadsController.class_eval do
  alias_method :old_blob_args, :blob_args

  # FIXME: testear
  def blob_args
    old_blob_args.merge(service_name: :local)
  end
end
