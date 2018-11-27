class CreateVestalVersions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :vestal_versions do |t|
      t.belongs_to :versioned, :polymorphic => true
      t.belongs_to :user, :polymorphic => true
      t.string  :user_name
      t.text    :modifications
      t.integer :number
      t.integer :reverted_from
      t.string  :tag

      t.timestamps
    end

    change_table :vestal_versions do |t|
      t.index [:versioned_id, :versioned_type]
      t.index [:user_id, :user_type]
      t.index :user_name
      t.index :number
      t.index :tag
      t.index :created_at
    end
  end

  def self.down
    drop_table :vestal_versions
  end
end
