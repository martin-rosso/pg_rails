# frozen_string_literal: true

class BulkEditComponent < BaseComponent
  def initialize(clase_modelo, params:, form: nil)
    @clase_modelo = clase_modelo
    @attributes = @clase_modelo.bulky_attributes
    @key = @clase_modelo.model_name.param_key
    @model = if params[@key].present?
               attrs = @clase_modelo.bulky_attributes.select { |bk| bk.to_s.in?(params[:active_fields] || []) }
               @clase_modelo.new(params[@key].permit(attrs))
             else
               @clase_modelo.new
             end
    @active_fields = params[:active_fields]
    @f = form
  end

  def before_render
    @f ||= PgFormBuilder.new(@key, @model, view_context, {})
  end
end
