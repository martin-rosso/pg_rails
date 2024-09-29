class DummyNavigator
  def configure(navbar)
    navbar.add_item('sidebar.signed_in', {
      name: 'Categorias front',
      path: 'users_categoria_de_cosas_path',
    })
    navbar.add_item('sidebar.signed_in', {
      name: 'Cosas front',
      path: 'users_cosas_path',
    })
    if Current.user&.developer?
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
end
