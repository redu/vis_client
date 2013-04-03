class Thing
  attr_accessor :statusable_type

  def initialize(statusable_type)
    @statusable_type = statusable_type
  end

  def to_hash
    object_hash = Hash.new
    self.instance_variables.each do |x|
      object_hash[x[1..-1]] = self.instance_variable_get(x)
    end
    object_hash
  end
end
