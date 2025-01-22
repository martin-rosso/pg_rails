class DummyNavigator
  def configure(navbar)
    if Current.namespace == :tenant
      navbar.add_item('sidebar.signed_in', {
        name: 'Categorias front',
        path: 'tenant_categoria_de_cosas_path',
        policy: 'policy(CategoriaDeCosa).index?'
      })
      navbar.add_item('sidebar.signed_in', {
        name: 'Cosas front',
        path: 'tenant_cosas_path',
        policy: 'policy(Cosa).index?'
      })
    end
    if Current.namespace == :admin
      navbar.add_item('sidebar.signed_in', {
        name: 'Categorias',
        path: 'admin_categoria_de_cosas_path',
      })
      navbar.add_item('sidebar.signed_in', {
        name: 'Cosas',
        path: 'admin_cosas_path',
      })
    end
  end
end

PgEngine.configurar do |config|
  config.navigators.prepend DummyNavigator.new
  config.add_profiles(:cosas, 5000)
  config.add_profiles(:categoria_de_cosas, 6000)
  config.health_ssl_urls.push(
    'https://bien.com.ar',
  )
end

require 'pg_engine/test/dummy_brand'

PgEngine.site_brand = PgEngine::Test::DummyBrand.new
