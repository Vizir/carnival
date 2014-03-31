module Carnival

  class AdminUser < ActiveRecord::Base

    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

    has_many :admin_user_notifications

    def unread_notifications
      self.admin_user_notifications.where(:read => false).to_a
    end

    def self.new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end

    def self.find_for_omni_auth(auth)
      if user = AdminUser.where(email: auth.info.email).first
        user.provider = auth.provider
        user.uid = auth.uid
        user
      else
        where(auth.slice(:provider, :uid)).first_or_create do |user|
          user.provider = auth.provider
          user.uid = auth.uid
          user.name = auth.info.name
          user.email = auth.info.email
          user.avatar = auth.info.image
          user.password = Devise.friendly_token[0,20]
        end
      end
    end
  end

end
