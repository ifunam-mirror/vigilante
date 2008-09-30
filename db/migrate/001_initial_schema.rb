class InitialSchema < ActiveRecord::Migration
  def self.up
    
    # AGENTS
    create_table :agents, :force => true do |t|
      t.string :name
    end
    
    # CODECS
    create_table :codecs, :force => true do |t|
      t.string :name, :extension
    end
    
    # QUALITIES
    create_table :qualities, :force => true do |t|
      t.string :name, :size
      t.string :compression
      t.integer :fps
    end

    # CAMERAS
    create_table :cameras, :force => true do |t|
      t.string :ip, :location, :description
      t.string :user, :password
      #t.string :strm_path, :strm_user, :strm_password, strm_ip # Maybe another table ??
      t.references :codec, :quality, :agent, :null => false
    end

    # VIDEOS
     create_table :videos, :force => true do |t|
       t.string :filename, :path
       t.integer :duration
       t.references :camera
       t.date :date
       t.string :start, :end
     end

    # ROLES
    create_table :roles, :force => true do |t|
      t.string :name
      t.text :description
    end

    # USERS
    create_table :users, :force => true do |t|
      t.string :login, :password, :email, :salt
      t.boolean :status, :is_admin, :default => false
      t.references :role
    end
    
  end

  def self.down
    drop_table :roles
    drop_table :videos
    drop_table :table_name
    drop_table :agents
    drop_table :users
    drop_table :cameras
    drop_table :codecs    
  end
end
