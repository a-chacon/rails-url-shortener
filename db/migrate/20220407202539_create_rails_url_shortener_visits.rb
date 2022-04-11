class CreateRailsUrlShortenerVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_url_shortener_visits do |t|
      t.belongs_to    :url
      # client ip
      t.string        :ip
      # browser from user_agent
      t.string        :browser
      # browser version from user_agent
      t.string        :browser_version
      # platform from user_agent
      t.string        :platform
      # platform version from user_agent
      t.string        :platform_version
      # if the request was a bot or not
      t.boolean       :bot
      t.string        :user_agent
      # variable where we save all data that can be catch from the request
      t.text          :meta

      t.timestamps
    end
  end
end
