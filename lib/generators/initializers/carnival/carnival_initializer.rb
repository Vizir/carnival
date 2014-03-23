Admin::Config.menu = {
                        :admin => {
                              :label => "aaa",
                              :class => "ssss",
                              :link => "ddd",
                              :subs => [
                                {
                                  :label => "menu.testes",
                                  :class => "tst",
                                  :link => "/admin/testes"
                                },
                                {
                                  :label => "55555",
                                  :class => "66666",
                                  :link => "777777"
                                }
                              ]
                        },
                        :locations => {
                          :label => "menu.locations",
                          :class => "",
                          :link => "#",
                          :subs => [
                            {
                              :label => "menu.countries",
                              :class => "countries",
                              :link => "/admin/countries"
                            },
                            {
                              :label => "menu.states",
                              :class => "states",
                              :link => "/admin/states"
                            },
                            {
                              :label => "menu.cities",
                              :class => "cities",
                              :link => "/admin/cities"
                            }
                          ]
                        }
                      }
BetterErrors::Middleware.allow_ip! '192.168.33.1'
BetterErrors::Middleware.allow_ip! "10.0.2.2" if defined? BetterErrors && Rails.env == :development

config.after_initialize do
  Bullet.enable = true
  Bullet.alert = true
  Bullet.bullet_logger = true
  Bullet.console = true
  Bullet.growl = false
  # Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
  #                 :password => 'bullets_password_for_jabber',
  #                 :receiver => 'your_account@jabber.org',
  #                 :show_online_status => true }
  # Bullet.rails_logger = true
  # Bullet.airbrake = true
  # Bullet.add_footer = true
end
