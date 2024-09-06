ActsAsTenant.without_tenant do
  DatabaseCleaner.clean_with(:truncation, except: %w(ar_internal_metadata))


  bien = FactoryBot.create :account, nombre: 'Bien', subdomain: 'bien'
  uno = FactoryBot.create :user, email: 'mrosso10@gmail.com', nombre: 'Martín', apellido: 'Rosso', password: 'admin123',
                           confirmed_at: Time.now, developer: true, orphan: true
  bien.users << uno

  mal = FactoryBot.create :account, nombre: 'Mal', subdomain: 'mal'
  otro = FactoryBot.create :user, email: 'mal@gmail.com', nombre: 'Mal', apellido: 'Mal', password: 'admin123',
                           confirmed_at: Time.now, developer: true, orphan: true

  mal.users << otro
end
