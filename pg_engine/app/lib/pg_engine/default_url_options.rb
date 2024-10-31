module PgEngine
  module DefaultUrlOptions
    # Aunque parece intuitivo que se podría definir solamente url_options,
    # es importante que default_url_options también esté definido
    def url_options
      if Current.active_user_account
        super.merge(tenant_id: Current.active_user_account.to_param)
      else
        super.merge(tenant_id: nil)
      end
    end

    def default_url_options
      if Current.active_user_account
        { tenant_id: Current.active_user_account.to_param }
      else
        { tenant_id: nil }
      end
    end
  end
end
