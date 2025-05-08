class AddRefererToVistis < ActiveRecord::Migration[7.0]
  def change
    add_column :rails_url_shortener_visits, :referer, :string, default: ""
  end
end
