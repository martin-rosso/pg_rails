DatabaseCleaner.clean_with(:truncation, except: %w(ar_internal_metadata))

bien = FactoryBot.create(:account, nombre: 'Bien', subdomain: 'bien')
rosso = FactoryBot.create(:user, email: 'mrosso10@gmail.com', nombre: 'Martín', apellido: 'Rosso', password: 'admin123',
                                 confirmed_at: Time.now, developer: true, orphan: true)

bien.user_accounts.create(user: rosso, profiles: [:administracion])

racionalismo = FactoryBot.create(:account, nombre: 'Racionalismo', subdomain: 'racionalismo')
baruch = FactoryBot.create(:user, email: 'baruch@bien.com', nombre: 'Baruch', apellido: 'Spinoza', password: 'admin123',
                                  confirmed_at: Time.now, orphan: true)
rené = FactoryBot.create(:user, email: 'rene@bien.com', nombre: 'René', apellido: 'Descartes', password: 'admin123',
                                confirmed_at: Time.now, orphan: true)

racionalismo.user_accounts.create(user: baruch, profiles: [:administracion])
racionalismo.user_accounts.create(user: rené, profiles: [:operacion])
