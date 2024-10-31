module PgEngine
  module DefaultUrlOptions
    # Aunque parece intuitivo que se podría definir solamente url_options,
    # es importante que default_url_options también esté definido
    def url_options
      if Current.active_user_account
        super.merge(tid: Current.active_user_account.to_param)
      else
        super.merge(tid: nil)
      end
    end

    def default_url_options
      if Current.active_user_account
        { tid: Current.active_user_account.to_param }
      else
        { tid: nil }
      end
    end
  end
end
