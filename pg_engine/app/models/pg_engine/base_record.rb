# frozen_string_literal: true

module PgEngine
  # rubocop:disable Rails/ApplicationRecord
  class BaseRecord < ActiveRecord::Base
    # rubocop:enable Rails/ApplicationRecord
    extend Enumerize
    include PrintHelper
    include PostgresHelper
    include Naming

    self.abstract_class = true

    before_create :setear_creado_y_actualizado_por
    before_update :setear_actualizado_por

    scope :unkept, -> { discarded }
    # ransacker :search do |parent|
    #   parent.table[:nombre]
    # end

    # Para el dom_id (index.html)
    def to_key
      if respond_to? :hashid
        [hashid]
      else
        super
      end
    end

    # overriden by PgEngine::ChildRecord
    def parent?
      false
    end

    def to_s
      %i[nombre name].each do |campo|
        # Using `_in_database` for consistent breadcrumbs when editing the name
        campo = :"#{campo}_in_database"

        return "#{send(campo)} ##{to_param}" if try(campo).present?
      end
      if to_param.present?
        "#{self.class.nombre_singular} ##{to_param}"
      else
        super
      end
    end

    private

    def setear_creado_y_actualizado_por
      setear_si_existe :creado_por, Current.user
      setear_si_existe :actualizado_por, Current.user
    end

    def setear_actualizado_por
      setear_si_existe :actualizado_por, Current.user
    end

    def setear_si_existe(campo, valor)
      metodo = "#{campo}="
      send(metodo, valor) if respond_to?(metodo) && valor.present?
    end
  end
end
