module Carnival
  class Config
    mattr_accessor :menu
    @@menu

    mattr_accessor :allow_signup
    @@allow_signup = false

  end
end
