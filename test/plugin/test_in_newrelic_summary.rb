require 'helper'

class NewRelicSummaryTest < Test::Unit::TestCase

  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    type newrelic_summary
    api_key NEWRELIC_API_KEY
    interval 5
    summary applications
    tag newrelic.summary
  ]

  def create_driver(conf=CONFIG, tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::NewRelicSummaryInput, tag).configure(conf)
  end

  def test_configuration
    d = create_driver
    assert_equal 'NEWRELIC_API_KEY', d.instance.api_key
    assert_equal 5, d.instance.interval
    assert_equal 'applications', d.instance.summary
    assert_equal 'newrelic.summary', d.instance.tag
  end

  def test_configuration_with_empty_tag
    assert_raise(Fluent::ConfigError) {
      create_driver %[
        type newrelic_summary
        api_key NEWRELIC_API_KEY
        interval 5
        summary applications
        # tag newrelic.summary
      ]
    }
  end

  def test_configuration_with_unknown_summary
    assert_raise(Fluent::ConfigError) {
      create_driver %[
        type newrelic_summary
        api_key NEWRELIC_API_KEY
        interval 5
        summary XXXXXXX
        tag newrelic.summary
      ]
    }
  end
end
