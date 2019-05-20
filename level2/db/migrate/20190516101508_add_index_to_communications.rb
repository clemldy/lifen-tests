class AddIndexToCommunications < ActiveRecord::Migration[5.2]
  def change
    add_index :communications, :practitioner_id
    add_foreign_key :communications, :practitioners, column: :practitioner_id
  end
end
