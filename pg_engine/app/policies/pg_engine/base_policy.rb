# frozen_string_literal: true

module PgEngine
  class BasePolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @record = record
    end

    def index?
      base_access_to_collection?
    end

    def archived?
      puede_ver_archivados? && base_access_to_collection?
    end

    def show?
      base_access_to_record?
    end

    def create?
      puede_crear?
    end

    def new?
      create?
    end

    def new_from_associable?
      new?
    end

    def update?
      puede_editar? && !record_discarded?
    end

    def edit?
      update?
    end

    def destroy?
      puede_borrar?
    end

    def archive?
      puede_ver_archivados? && puede_editar? && record.respond_to?(:discard) && record.kept?
    end

    def restore?
      puede_ver_archivados? && puede_editar? && record.respond_to?(:undiscard) && record.discarded? &&
        (!record.parent? || record.parent.kept?)
    end

    def scope
      Pundit.policy_scope!(user, record.class)
    end

    class Scope
      attr_reader :user, :scope

      def initialize(user, scope)
        @user = user
        @scope = scope
      end

      def resolve
        if policy.base_access_to_collection?
          scope.all
        else
          scope.none
        end
      end

      def policy
        raise "el scope debe ser una clase modelo y no #{scope.class}" unless scope.class

        Pundit.policy!(user, scope)
      end
    end

    def puede_editar?
      user_has_profile(:update)
    end

    def puede_crear?
      user_has_profile(:create)
    end

    def puede_borrar?
      user_has_profile(:destroy)
    end

    def puede_ver_archivados?
      user_has_profile(:archive)
    end

    def base_access_to_record?
      user_has_profile(:read)
    end

    def base_access_to_collection?
      user_has_profile(:read)
    end

    def export?
      user_has_profile(:export)
    end

    def record_discarded?
      if record.respond_to?(:kept?)
        !record.kept?
      else
        false
      end
    end

    def profile_prefix
      record.model_name.plural
    end

    def user_has_profile(key)
      return false if user.blank?
      return true if user.developer?

      full_key = "#{profile_prefix}__#{key}"
      user.owns_current_account? || user.current_profiles.include?(full_key)
    end
  end
end
