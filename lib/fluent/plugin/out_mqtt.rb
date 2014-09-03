module Fluent
  class MqttOutput < Output
    Plugin.register_output('mqtt', self)

    include Fluent::SetTagKeyMixin
    config_set_default :include_tag_key, false

    include Fluent::SetTimeKeyMixin
    config_set_default :include_time_key, true

    config_param :port, :integer, :default => 1883
    config_param :bind, :string, :default => '127.0.0.1'
    config_param :username, :string, default: nil
    config_param :password, :string, default: nil

    def initialize
      require 'mqtt'
    end

    def configure(conf)
      super
      $log.debug 'config'
      @bind ||= conf['bind']
      @port ||= conf['port']
      @username ||= conf['username']
      @password ||= conf['password']
    end

    def start
      super
      $log.debug "start mqtt #{@bind}"
      @connect = MQTT::Client.connect({host: @bind, port: @port, username: @username, password: @password})
      @connect
    end

    def emit tag, es, chain
      $log.debug 'emit'
      chain.next
      es.each {|time, record|
        $log.debug time
        $log.debug record
        @connect.publish(tag.gsub(".","/"), record.to_json)
      }
    end

    def shutdown
      @connect.disconnect
      $log.debug "stop mqtt #{@bind}"
      super
    end
  end
end

