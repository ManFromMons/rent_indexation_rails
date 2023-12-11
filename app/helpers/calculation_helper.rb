module CalculationHelper
  require 'date'
  require 'http'

  def get_appropriate_year(the_date)
    years = [1998, 1996, 2004, 2013]

    years.select { |year| year <= the_date.year }.max
  end

  def a_year_before(a_date)
    a_date.years_ago(1)
  end

  def a_month_before(a_date)
    a_date.months_ago(1)
  end

  def fetch_health_index base_year, max_year, max_month
    # puts "https://fi7661d6o4.execute-api.eu-central-1.amazonaws.com/prod/be/indexes/#{base_year}/#{max_year}-#{max_month}"
    result = HTTP.get("https://fi7661d6o4.execute-api.eu-central-1.amazonaws.com/prod/be/indexes/#{base_year}/#{max_year}-#{max_month}").parse["index"]
    # puts "http result #{result}"

    result
  end

  def safely_fetch_health_index(base_year, month, year)
    result = fetch_health_index(base_year, year, month)

    return false unless result

    return false if result.kind_of?(Array)

    result.symbolize_keys
  rescue
    raise "External service not available"
  end

  def get_health_index(month, base_year)
    health_data = safely_fetch_health_index(base_year, month.month, month.year)

    raise "No data available" if health_data == false

    health_data[:MS_HLTH_IDX]
  end

  def get_last_birthday(start_date, current_date)
    anchor_date = Date.new(current_date.year, start_date.month, start_date.day)
    a_year_before a_month_before anchor_date
  end

  def get_base_index(base_month, base_year)
    get_health_index(base_month, base_year)
  rescue StandardError => e
    raise "Base health-index cannot be calculated with #{base_month}-#{base_year}: #{e}"
  end

  def get_current_index(base_month, base_year)
    get_health_index(base_month, base_year)
  rescue StandardError => e
    raise "Current health-index cannot be calculated with #{base_month}-#{base_year}: #{e}"
  end

  def calculate_new_rent(input_data)
    base_month = a_month_before input_data[:signed_on]
    base_year = get_appropriate_year base_month
    current_month = get_last_birthday input_data[:start_date], input_data[:current_date]

    base_index = get_base_index(base_month, base_year)
    current_index = get_current_index(current_month, base_year)

    new_rent = perform_index_calculation({
                                           base_rent: input_data[:base_rent],
                                           current_index: current_index,
                                           base_index: base_index
                                         })

    { new_rent: new_rent.round(2),
      base_index: base_index,
      current_index: current_index
    }
  end

  def perform_index_calculation(calculation_data)
    (calculation_data[:base_rent] * calculation_data[:current_index]) /
      calculation_data[:base_index]
  end
end
