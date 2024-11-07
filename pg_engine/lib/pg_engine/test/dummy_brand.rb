module PgEngine
  module Test
    class DummyBrand < PgEngine::SiteBrand
      def self.configurations # rubocop:disable Metrics/MethodLength
        aux = {
          landing_site_url: {
            procura: 'https://bien.com.ar/procura',
            factura: 'https://bien.com.ar/factura'
          },
          logo_navbar_url: {
            procura: 'procura-logo-navbar-1.png',
            factura: 'logo-navbar-1.png'
          },
          logo_xl_url: {
            procura: 'procura-logo-xl-light.png',
            factura: 'logo-xl-light.png'
          },
          favicon_prefix: {
            procura: 'procura-favicon',
            factura: 'favicon'
          },
          mailer_devise_footer_image_src: {
            factura: 'mail-footer-lg.png',
            procura: 'procura-mail-footer-lg.png'
          },
          mailer_base_footer_image_src: {
            factura: 'footer-mail-dark-light.png',
            procura: 'procura-mail-footer-sm.png'
          },
          default_mail_from: {
            procura: 'noreply@procura',
            factura: 'noreply@factura'
          },
          name: {
            procura: 'Procura Bien',
            factura: 'Factura Bien'
          },
          default_mail_from_name: {
            procura: 'Procura Bien',
            factura: 'Factura Bien'
          },
          default_url_options: {
            default: {}
          }
        }

        if Rails.env.local?
          aux.merge!({
                       default_url_options: {
                         procura: {
                           host: 'procura.localhost',
                           port: '3000'
                         },
                         factura: {
                           host: 'factura.localhost',
                           port: '3000'
                         }
                       }
                     })
        end

        aux
      end

      def account_plan_options
        { factura: 0, procura: 1 }
      end

      def detect(request)
        return :procura if request.host.match(/procura/)
        return :factura if request.host.match(/factura/)

        pg_warn 'default site_brand assigned'

        :factura
      end

      def self.default_site_brand
        :factura
      end

      define_methods_for_symbols
    end
  end
end
