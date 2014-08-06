module Carnival

  class AdminUser < ActiveRecord::Base

    include Carnival::ModelHelper
    devise_flags = *Carnival::Config.devise_config
    devise_flags << :recoverable
    devise_flags << :rememberable

    if devise_flags.include?(:omniauthable)
      devise :database_authenticatable, *devise_flags.uniq, omniauth_providers: Carnival::Config.omniauth_providers
    else
      devise :database_authenticatable, *devise_flags.uniq
    end

    has_many :admin_user_notifications
    has_many :notifications, through: :admin_user_notifications

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
      elsif Carnival::Config.devise_config.include?(:registerable)
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
