module PgEngine
  module Test
    class DummyBrand < PgEngine::SiteBrand
      def initialize(skip_default_url_options: Rails.env.test?)
        super()

        @default_site_brand = :factura

        @options = {
          landing_site_url: { # Se usa en el footer de los mails
            procura: 'https://procura.bien.com.ar',
            factura: 'https://factura.bien.com.ar'
          },
          logo_navbar_url: {
            procura: 'test/procura-logo-navbar-1.png',
            factura: 'test/factura-logo-navbar-1.png'
          },
          logo_xl_url: {
            procura: 'test/procura-logo-xl-light.png',
            factura: 'test/factura-logo-xl-light.png'
          },
          favicon_prefix: {
            procura: 'test/icon/procura-favicon',
            factura: 'test/icon/factura-favicon'
          },
          mailer_devise_footer_image_src: {
            factura: 'test/factura-mail-footer-lg.png',
            procura: 'test/procura-mail-footer-lg.png'
          },
          mailer_base_footer_image_src: {
            factura: 'test/factura-mail-footer-sm.png',
            procura: 'test/procura-mail-footer-sm.png'
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

        return if skip_default_url_options

        @options.merge!({
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

      def account_plan_options
        { factura: 0, procura: 1 }
      end

      def detect(request)
        return :procura if request.host.match(/procura/)
        return :factura if request.host.match(/factura/)

        pg_warn 'default site_brand assigned' unless Rails.env.local?

        :factura
      end
    end
  end
end
