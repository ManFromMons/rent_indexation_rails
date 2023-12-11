require 'test_helper'
require 'date'

class CalculationHelperTest < ActionView::TestCase
  test 'get appropriate date for 2010 will return 2004' do
    origin_date = Date.new(2010, 10, 01)
    result = get_appropriate_year(origin_date)

    assert_equal(2004, result, "The return value of #{result}, calculate from #{origin_date} must be 2004")
  end

  test 'when using service with known bad value, expect an error element' do
    result = fetch_health_index(2014, 2000, 1)
    expected = JSON.parse('{
                            "index": ["not_found"]}' )

    assert_equal(expected, result)
  end

  test 'when using service with known good value, expect an index element' do
    result = fetch_health_index(2004, 2000, 1)
    expected = JSON.parse('{
                            "index": {
                              "MS_SMOOTH_IDX": 91.37,
                              "MS_WT_CPI": 1000,
                              "MS_CPI_IDX": 91.19,
                              "MS_HLTH_IDX": 91.67,
                              "SK": "2000_01",
                              "NM_BASE_YR": 2004,
                              "NM_MTH": 1,
                              "NM_YR": 2000,
                              "PK": "2004"
                            }}' )

    assert_equal(expected, result)
  end

  test 'when using supplied test data, results should be correct' do
    result = calculate_new_rent({signed_date: Date.parse('2010-07-25'),
                                 start_date: Date.parse('2010-09-01'),
                                 current_date: Date.parse('2020-01-01'),
                                 base_rent: 500,
                                 region: 'brussels'})

    assert_equal(584.18, result[:new_rent])
  end
end