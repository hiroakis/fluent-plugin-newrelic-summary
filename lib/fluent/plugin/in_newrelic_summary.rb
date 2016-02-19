require 'net/https'

module Fluent
  class NewRelicSummaryInput < Input
    Plugin.register_input('newrelic_summary', self)

    NEW_RELIC_API_DOMAIN = 'api.newrelic.com'
    SUMMARIES = %w(applications servers key_transactions)

    config_param :tag, :string, :default => nil
    config_param :api_key, :string, :defaut => nil, :secret => true
    config_param :summary, :string, :default => "applications"
    config_param :interval, :integer, :default => 60 # sec

    unless method_defined?(:log)
      define_method("log") { $log }
    end

    def initialize
      super
    end

    def configure(conf)
      log.trace "in_newrelic_summary: configure"
      super

      if @tag.nil?
        raise Fluent::ConfigError, "newrelic_summary: 'tag' parameter is required"
      end
      unless SUMMARIES.include?(@summary)
        raise Fluent::ConfigError, "newrelic_summary: no such 'summary' parameter. summary should be applications, servers or key_transactions"
      end
    end

    def start
      log.trace "in_newrelic_summary: start"
      super

      @thread = Thread.new(&method(:run))
    end

    def shutdown
      log.trace "in_newrelic_summary: shutdown"
      super

      Thread.kill(@thread)
    end

    def run
      log.trace "in_newrelic_summary: run"

      loop do
        http = Net::HTTP.new(NEW_RELIC_API_DOMAIN, 443)
        http.use_ssl = true
        uri = "/v2/#{@summary}.json"
        req = Net::HTTP::Get.new(uri)
        req["NewRelic-Api-Key"] = @api_key
        res = http.request(req)

        case res
        when Net::HTTPSuccess
          emit_data(JSON.parse(res.body))
        else
          log.error "in_newrelic_summary: error"
        end
        sleep @interval
      end
    end # The end of run method

    def emit_data(data)
      log.trace "in_newrelic_summary: emit_data"
      router.emit("#{tag}", Engine.now, data)
    end
  end
end
