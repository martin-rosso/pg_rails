# :nocov:
module PgEngine
  module TpathSupport
    module RequestsPatch
      def get(url, **)
        super(tpath(url), **)
      end

      def post(url, **)
        super(tpath(url), **)
      end

      def put(url, **)
        super(tpath(url), **)
      end

      def patch(url, **)
        super(tpath(url), **)
      end

      def delete(url, **)
        super(tpath(url), **)
      end

      def redirect_to(arg, tpath: true)
        if tpath
          super(tpath(arg, query_string: false))
        else
          super(arg)
        end
      end
    end

    module ControllersPatch
      def redirect_to(arg, tpath: true)
        if tpath
          super(tpath(arg, query_string: false))
        else
          super(arg)
        end
      end
    end

    def _tpath_ua
      usr = if respond_to?(:logged_user)
              logged_user
            elsif respond_to?(:user)
              user
            else
              raise 'no user available'
            end

      raise 'user is null' if usr.nil?

      usr.active_user_account_for(ActsAsTenant.current_tenant)
    end

    def tpath(arg, query_string: true)
      ua = _tpath_ua
      return arg.push(tid: ua.to_param) if arg.is_a? Array

      path = arg

      if query_string
        "#{path}?tid=#{ua.to_param}"
      else
        # "/u/t/#{ua.to_param}#{path}"
        path.sub('/u/t/', "/u/t/#{ua.to_param}/")
      end
    end
  end
end
# :nocov:
