namespace :carnival do
  desc "Carnival Admin Tasks"
  namespace :users do
    task :add_admin, [:email, :password] => :environment do |t, args|
      Carnival::AdminUser.create email: args[:email], password: args[:password], password_confirmation: args[:password]
    end
  end
end
