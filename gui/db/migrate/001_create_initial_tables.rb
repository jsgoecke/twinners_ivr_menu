class CreateInitialTables < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.string :name, :audio_file
      t.integer :playback_order
      t.integer :station_id
      t.datetime :created_at
      t.datetime :updated_at
    end
    
    create_table :options do |t|
      t.string :name
      t.integer :option_number, :menu_id
      t.datetime :created_at
      t.datetime :updated_at
    end
    
    create_table :users do |t|
      t.string   :crypted_password, :limit => 40
      t.string   :salt, :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :username
      t.boolean  :administrator, :default => false
      t.datetime :created_at
      t.datetime :updated_at
    end
    
    create_table :stations do |t|
      t.string :name
      t.integer :timeout, :tries
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :menus
    drop_table :options
    drop_table :users
    drop_table :stations
  end
end
