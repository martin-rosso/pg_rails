class DummyNavigator
  def configure(navbar)
    if Current.namespace == :users
      navbar.add_item('sidebar.signed_in', {
        name: 'Categorias front',
        path: 'users_categoria_de_cosas_path',
        policy: 'policy(CategoriaDeCosa).index?'
      })
      navbar.add_item('sidebar.signed_in', {
        name: 'Cosas front',
        path: 'users_cosas_path',
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
end
