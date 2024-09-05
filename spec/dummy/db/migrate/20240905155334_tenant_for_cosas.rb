class TenantForCosas < ActiveRecord::Migration[7.2]
  def change
    add_reference :categoria_de_cosas, :account, index: true, foreign_key: true
    add_reference :cosas, :account, index: true, foreign_key: true
  end
end
