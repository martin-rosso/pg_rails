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
      base_access_to_collection?
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
      puede_borrar? && record.respond_to?(:discard) && !record_discarded?
    end

    def restore?
      puede_borrar? && record.respond_to?(:discard) && record.discarded?
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
      base_access_to_record?
    end

    def puede_crear?
      base_access_to_collection?
    end

    def puede_borrar?
      base_access_to_record?
    end

    def export?
      base_access_to_collection?
    end

    def base_access_to_record?
      user&.developer?
    end

    def base_access_to_collection?
      user&.developer?
    end

    def record_discarded?
      if record.respond_to?(:kept?)
        !record.kept?
      else
        false
      end
    end
  end
end
