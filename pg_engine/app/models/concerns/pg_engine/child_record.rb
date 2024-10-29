module PgEngine
  module ChildRecord
    extend ActiveSupport::Concern

    included do
      scope :kept, -> { undiscarded.joins(klass.parent_accessor).merge(klass.parent_klass.kept) }
      scope :unkept, -> { discarded.joins(klass.parent_accessor).or(klass.parent_klass.discarded) }
    end

    class_methods do
      def parent_klass
        self.reflect_on_all_associations.select { |r| r.name == self.parent_accessor.to_sym }.first.klass
      end
    end

    def kept?
      undiscarded? && (parent.blank? || parent.kept?)
    end
  end
end
