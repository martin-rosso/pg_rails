DatabaseCleaner.clean_with(:truncation, except: %w(ar_internal_metadata))

FactoryBot.create :user, email: 'mrosso10@gmail.com', nombre: 'Martín', apellido: 'Rosso', password: 'admin123',
                         confirmed_at: Time.now, developer: true

Account.first.users << FactoryBot.create(:user, orphan: true)
