require 'helper'
require 'fluent/plugin/out_mqtt'

class MqttOutputTest < Test::Unit::TestCase

  def setup
    Fluent::Test.setup
  end


  CONFIG = %[
  ]

  def create_driver(conf = CONFIG, tag=nil)
    Fluent::Test::OutputTestDriver.new(Fluent::MqttOutput,tag).configure(conf)
  end

  def test_configure
    d = create_driver(
      %[
        bind 127.0.0.1
        port 1300
        username hoge
        password fuga
      ]
    )
    assert_equal '127.0.0.1', d.instance.bind
    assert_equal 1300, d.instance.port
    assert_equal 'hoge', d.instance.username
    assert_equal 'fuga', d.instance.password
  end

  def test_emit
    d = create_driver(CONFIG,'test.tag')
    time = Time.parse("2011-01-02 13:14:15 UTC").to_i

    sub_client.subscribe '#'

    d.run do
      d.emit({"a"=>1}, time)
      d.emit({"b"=>"B"}, time)
      d.emit({"c"=> [ 'd' ]}, time)
    end

    assert_equal ["test/tag", '{"a":1}'], sub_client.get
    assert_equal ["test/tag", '{"b":"B"}'], sub_client.get
    assert_equal ["test/tag", '{"c":["d"]}'], sub_client.get

  end

  def sub_client(d = create_driver)
    @client ||= MQTT::Client.connect(
      host: d.instance.bind,
      port: d.instance.port,
      username: d.instance.username,
      password: d.instance.password
    )
  end

end
