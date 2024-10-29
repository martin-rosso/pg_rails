module PgEngine
  module FrameHelper
    # Will the current view rendered in a modal?
    def using_modal?
      controller.instance_variable_get(:@using_modal) ||
        modal_targeted?
    end

    def using_modal2?
      @using_modal || modal_targeted?
    end

    def in_modal?
      request.headers['Modal-Opened'] == 'true'
    end

    def current_turbo_frame
      request.headers['Turbo-Frame']
    end

    def turbo_frame?
      current_turbo_frame.present?
    end

    def modal_targeted?
      current_turbo_frame.present? &&
        current_turbo_frame.start_with?('modal_content')
    end

    def frame_embedded?
      turbo_frame? && current_turbo_frame.include?('embedded')
    end

    def embed_index(object, key)
      reflection = object.class.reflect_on_all_associations.find do |a|
        a.name == key.to_sym
      end

      if reflection.blank?
        # :nocov:
        raise PgEngine::Error, "#{key} not an association for #{object.class}"
        # :nocov:
      end

      return unless policy(reflection.klass).index?

      content_tag(:div, 'data-controller': 'embedded-frame') do
        turbo_frame_tag "embedded--#{key}",
                        refresh: :morph, src: url_for([pg_namespace, object, key]) do
          content_tag(:p, class: 'p text-body-secondary text-center') { 'Cargando...' }
        end
      end
    end

    def nav_bg
      if frame_embedded?
        'bg-warning bg-opacity-25'
      elsif using_modal?
        'bg-warning bg-opacity-50'
      else
        'bg-primary-subtle'
      end
    end
  end
end
