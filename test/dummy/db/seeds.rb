# encoding: utf-8

Carnival::AdminUser.create(email: "admin@vizir.com.br", password: "12345678", password_confirmation: "12345678");

brazil = Admin::Country.create(name: 'Brazil', code: 'BR')

sp = Admin::State.create(:name => 'São Paulo', code: 'SP', country: brazil)

Admin::City.create(name: 'São Paulo', state: sp, country: brazil)
Admin::City.create(name: 'Campinas', state: sp, country: brazil)

rj = Admin::State.create(:name => 'Rio de Janeiro', code: 'RJ', country: brazil)

Admin::City.create(name: 'Angra dos Reis', state: rj, country: brazil)
Admin::City.create(name: 'Barra Mansa', state: rj, country: brazil)
