class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
      t.integer :taggings_count, :default => 0, :null => false
    end
  end

  def self.down
    drop_table :tags
  end
end