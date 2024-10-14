module PgEngine
  module I18nRules
    def self.rule(text)
      lambda do |key, options|
        male = options[:model].gender == 'm'
        model_plural = options[:model].nombre_plural
        model_singular = options[:model].nombre_singular
        text.gsub(/^%{plural_model}/, model_plural)
            .gsub(/^%{singular_model}/, model_singular)
            .gsub('%{plural_model}', model_plural.downcase)
            .gsub('%{singular_model}', model_singular.downcase)
            .gsub(/%{genderize\((?<female>(?:(?!%{).)+),(?<male>(?:(?!%{).)+)\)}/, male ? '\k<male>' : '\k<female>' )
      end
    end
  end
end

{
  :es => {
    pg_engine: {
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
          back_to_index: 'Volver al listado principal'
        }
      }
    }
  }
}
