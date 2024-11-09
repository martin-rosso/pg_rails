module PgEngine
  module Test
    class DummyBrand < PgEngine::SiteBrand
      def initialize(include_all: false) # rubocop:disable Metrics/MethodLength
        super()

        @default_site_brand = :factura

        @options = {
          landing_site_url: {
            procura: 'https://bien.com.ar/procura',
            factura: 'https://bien.com.ar/factura'
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

        return unless Rails.env.development? || include_all

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

        pg_warn 'default site_brand assigned'

        :factura
      end
    end
  end
end
