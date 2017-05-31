module Autobot::D1
  class Base

    def client
      @client ||= BungieClient::Wrappers::Default.new({
        :api_key => Rails.application.secrets.bungie_api_key
      })
    end

    def user
      Refinery::Authentication::Devise::User.first
    end

  end
end

require 'autobot/d1/weekly_reset'
