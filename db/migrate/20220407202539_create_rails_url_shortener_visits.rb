class CreateRailsUrlShortenerVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_url_shortener_visits do |t|
      t.belongs_to    :url

      t.string        :ip
      t.string        :user_agent
      # variable where we save all data that can be catch from the request
      t.text          :meta

      t.timestamps
    end
  end
end
