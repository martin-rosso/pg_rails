module PgEngine
  module ChildRecord
    extend ActiveSupport::Concern

    included do
      scope :kept, -> { undiscarded.joins(klass.parent_accessor).merge(klass.parent_klass.kept) }
      scope :unkept, -> { discarded.joins(klass.parent_accessor).or(klass.parent_klass.discarded) }
    end

    class_methods do
      attr_accessor :parent_accessor

      def parent_klass
        if parent_accessor.blank?
          # :nocov:
          raise PgEngine::Error, 'parent_accessor must be present'
          # :nocov:
        end

        reflection = reflect_on_all_associations.select { |r| r.name == parent_accessor.to_sym }.first
        if reflection.blank?
          # :nocov:
          raise PgEngine::Error, "#{parent_accessor} not an association on #{self}"
          # :nocov:
        end

        reflection.klass
      end
    end

    def parent?
      if self.class.parent_accessor.blank?
        # :nocov:
        raise PgEngine::Error, 'parent_accessor must be present'
        # :nocov:
      end

      true
    end

    def parent
      if self.class.parent_accessor.blank?
        # :nocov:
        raise PgEngine::Error, 'parent_accessor must be present'
        # :nocov:
      end

      send(self.class.parent_accessor)
    end

    def kept?
      undiscarded? && (parent.blank? || parent.kept?)
    end
  end
end
