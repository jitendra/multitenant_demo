class RenameMicropostsTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :microposts, :tweets
  end
end
