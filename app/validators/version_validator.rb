class VersionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "must be a valid Version") unless version_valid?(value)    
  end

  def version_valid?(v)
    numbers = v.split('.')
    numbers.map! {|x| x.to_i }
    numbers.count == 3 && (numbers[0].is_a? Integer) && (numbers[1].is_a? Integer) && (numbers[2].is_a? Integer)
  end 
end