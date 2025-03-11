module PgEngine
  module I18nRules
    def self.rule(text)
      lambda do |key, options|
        male = options[:model].gender == 'm'
        model_plural = options[:model].nombre_plural
        model_singular = options[:model].nombre_singular
        pluralized_model = options[:count].present? && options[:count] > 1 ? model_plural : model_singular
        text.gsub(/^%{plural_model}/, model_plural)
            .gsub(/^%{singular_model}/, model_singular)
            .gsub(/^%{pluralized_model}/, pluralized_model)
            .gsub('%{plural_model}', model_plural.downcase)
            .gsub('%{singular_model}', model_singular.downcase)
            .gsub('%{pluralized_model}', pluralized_model.downcase)
            .gsub(/%{genderize\((?<female>(?:(?!%{).)+),(?<male>(?:(?!%{).)+)\)}/, male ? '\k<male>' : '\k<female>' )
      end
    end
  end
end

{
  :es => {
    pg_engine: {
      leave_account: PgEngine::I18nRules.rule('Dejar %{genderize(la,el)} %{singular_model}'),

      resource_destroyed: PgEngine::I18nRules.rule("Se eliminó %{genderize(la,el)} %{singular_model}"),
      resource_not_destroyed: PgEngine::I18nRules.rule("Hubo un error al intentar eliminar %{genderize(la,el)} %{singular_model}"),
      resource_not_updated: PgEngine::I18nRules.rule("Hubo un error al intentar actualizar %{genderize(la,el)} %{singular_model}"),
      resource_not_destroyed_because_associated: PgEngine::I18nRules.rule("No se pudo eliminar %{genderize(la,el)} %{singular_model} porque está asociado a otros elementos"),
      base: {
        index: {
          archived: {
            empty_but_filtered: PgEngine::I18nRules.rule("No hay %{genderize(ninguna,ningún)} %{singular_model} %{genderize(archivada,archivado)} para los filtros aplicados"),
            empty: PgEngine::I18nRules.rule("No hay %{genderize(ninguna,ningún)} %{singular_model} %{genderize(archivada,archivado)}"),
          },
          index: {
            empty_but_filtered: PgEngine::I18nRules.rule("No hay %{genderize(ninguna,ningún)} %{singular_model} para los filtros aplicados"),
            empty: PgEngine::I18nRules.rule("No hay %{genderize(ninguna,ningún)} %{singular_model} que mostrar"),
          },
          youre_in_archived_index: PgEngine::I18nRules.rule("Estás viendo el listado de %{plural_model} %{genderize(archivadas,archivados)}"),
          see_archived: PgEngine::I18nRules.rule("%{plural_model} %{genderize(archivadas,archivados)}"),
          back_to_index: 'Volver al listado principal',
          bulk_edit: {
            enqueue_update: "Modificación en proceso (podría demorar algunos segundos en completarse)",
            blank_ids: PgEngine::I18nRules.rule("No hay %{genderize(ninguna,ningún)} %{singular_model} %{genderize(seleccionada,seleccionado)}"),
            bulk_not_hash: "Debés seleccionar al menos un campo",
            title: PgEngine::I18nRules.rule("Modificación masiva de %{plural_model}"),
            link: PgEngine::I18nRules.rule("Modificar masivamente"),
            count: PgEngine::I18nRules.rule("%{count} %{pluralized_model} en total"),
          }
        }
      }
    }
  }
}
