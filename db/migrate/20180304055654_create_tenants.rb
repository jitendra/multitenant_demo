class CreateTenants < ActiveRecord::Migration[5.1]
  def change
    create_table :tenants do |t|
    	t.string :name
      t.string :slug
      t.string :url

      t.timestamps
    end

    add_index :tenants, :name, unique: true
    add_index :tenants, :slug, unique: true
  end
end
