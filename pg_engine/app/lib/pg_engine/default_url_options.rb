module PgEngine
  # Setea el tid
  #
  # Se usa en controllers, y en todo contexto dentro de la webapp
  # NO se usa en Mailers, ya que no requieren tid
  module DefaultUrlOptions
    # Aparentemente es necesario definir url_options cuando los parámetros
    # pueden cambiar a lo largo del lifecycle de la request
    def url_options
      super.merge(PgEngine.site_brand.default_url_options).merge(tid: _current_tid)
    end

    # Aunque parece intuitivo que se podría definir solamente url_options,
    # es importante que default_url_options también esté definido
    def default_url_options
      PgEngine.site_brand.default_url_options.merge(tid: _current_tid)
    end

    def _current_tid
      return unless Current.active_user_account

      Current.active_user_account.to_param
    end
  end
end
