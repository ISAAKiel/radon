class Search

  attr_reader :keyword
  
  def self.find(param)
    all.detect { |search| search.to_param == param } || raise(ActiveRecord::RecordNotFound)
  end

end
