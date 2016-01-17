# fluent-plugin-newrelic-summary

Fluentd input plugin to receive NewRelic summary data.

Please visit below link for the specification of NewRelic summary API.
https://docs.newrelic.com/docs/apis/rest-api-v2/application-examples-v2/summary-data-examples-v2

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-newrelic-summary'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-newrelic-summary

## Usage

The following is an example of configuration.

```
<source>
  type newrelic_summary
  api_key xxxxxxxxx
  interval 60 # sec. default is 60 sec.
  summary applications|servers|key_transactions
</source>
```

## Contributing

1. Fork it ( http://github.com/hiroakis/fluent-plugin-newrelic-summary/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

MIT
