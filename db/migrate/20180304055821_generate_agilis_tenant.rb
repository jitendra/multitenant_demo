class GenerateAgilisTenant < ActiveRecord::Migration[5.1]
  def up
  	Tenant.create!(name: 'Agilis AS', slug: 'agilis', url: 'agilis.local:3000')
  end

  def down
  end
end
