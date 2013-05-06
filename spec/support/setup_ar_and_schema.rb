ActiveRecord::Base.establish_connection(:adapter => 'sqlite3',
                                        :database => ':memory:')

ActiveRecord::Schema.define do
  create_table :things, :force => true do |t|
    t.string :statusable_type
  end
end

# Models
class Thing < ActiveRecord::Base
  def to_hash
    attrs = self.attributes
    attrs.delete("id")
    attrs
  end
end
