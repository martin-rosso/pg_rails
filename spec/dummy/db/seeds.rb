DatabaseCleaner.clean_with(:truncation,except: %w(ar_internal_metadata))

FactoryBot.create_list :user, 5
FactoryBot.create_list :categoria_de_cosa, 10