# frozen_string_literal: true

module PgEngine
  module RouteHelper
    class NamespaceDeductor
      def self.controller(context)
        if context.respond_to?(:request) && context.request
          # Controllers
          context
        elsif context.respond_to?(:helpers) && context.helpers
          # Decorators
          context.helpers.controller
        elsif context.respond_to?(:template) && context.template
          # FormBuilders
          context.template.controller
        end
      end

      def self.current_route(context)
        controller = controller(context)
        # Sólo si hay un controller de verdá
        return if controller.instance_of? ApplicationController

        req = controller.request
        Rails.application.routes.recognize_path(req.path, method: req.env['REQUEST_METHOD'])
      end

      def self.namespace(context)
        return Current.namespace if Current.namespace.present?

        route = current_route(context)
        return if route.blank?

        parts = route[:controller].split('/')
        return unless parts.length > 1

        parts.first.to_sym
      rescue ActionController::RoutingError
        nil
      end
    end

    def pg_current_route
      NamespaceDeductor.current_route(self)
    end

    def pg_namespace
      NamespaceDeductor.namespace(self)
    end

    def namespaced_path(object, options = {})
      target = [pg_namespace, object]

      if options[:prefix]
        target.prepend options[:prefix]
        options.delete(:prefix)
      end

      if options[:suffix]
        target.append options[:suffix]
        options.delete(:suffix)
      end

      polymorphic_url(target.flatten.compact, options.merge(only_path: true))
    end

    def path_for(array)
      url_for(array.push({ only_path: true }))
    end

    def context_root_path
      if Current.tid.present?
        tenant_root_path(tid: Current.tid)
      else
        (Current.user.present? ? user_root_path : root_path)
      end
    end

    # :nocov:
    deprecate :users_root_path, deprecator: PgEngine.deprecator
    def users_root_path
      user_root_path
    end
    # :nocov:
  end
end
