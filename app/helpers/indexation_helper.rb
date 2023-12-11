module IndexationHelper
  require 'date'
  include CalculationHelper

  def date_is_valid?(the_date)
    the_date.gsub!('-', '/')
    year, month, day = the_date.split('/').reverse.map(&:to_i)
    if ( year < day )
      year, month, day = the_date.split('/').map(&:to_i)
    end
    Date.valid_date?(year, month, day)
  rescue
    false
  end

  def is_number?(string)
    return true if Float(string)

  rescue
    true if Integer(string)

  rescue
    false
  end

  def calculate(form_data)
    puts "calculating for #{form_data}"
    calculate_new_rent(form_data)
  end
end
