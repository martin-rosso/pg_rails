module PgEngine
  module FlashHelper
    def render_turbo_stream_flash_messages(to: nil)
      if to.present?
        turbo_stream.prepend_all to, partial: 'pg_layout/flash'
      else
        turbo_stream.prepend 'flash', partial: 'pg_layout/flash'
      end
    end

    def render_turbo_stream_title
      title = [breadcrumbs.last&.name, ActsAsTenant.current_tenant,
               PgEngine.site_brand.name].compact.join(' - ')
      turbo_stream.update_all 'title', title
    end
  end
end
