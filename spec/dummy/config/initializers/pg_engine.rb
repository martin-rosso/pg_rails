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
  config.user_profiles.merge!(
    cosas__read: 5001,
    cosas__write: 5010,
    cosas__archive: 5050,
    cosas__destroy: 5100,
    categoria_de_cosas__read: 6001,
    categoria_de_cosas__write: 6010,
    categoria_de_cosas__archive: 6050,
    categoria_de_cosas__destroy: 6100,
  )
end
