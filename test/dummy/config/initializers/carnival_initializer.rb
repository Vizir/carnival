Carnival::Config.menu = {
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
