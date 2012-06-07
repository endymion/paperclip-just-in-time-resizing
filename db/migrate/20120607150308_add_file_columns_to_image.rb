class AddFileColumnsToImage < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.has_attached_file :attachment
    end
  end

  def self.down
    drop_attached_file :images, :attachment
  end
end