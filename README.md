# Fluent::Plugin::Mqtt

Fluent plugin for MQTT protocol

## Installation

Add this line to your application's Gemfile:

    $ gem 'fluent-plugin-mqtt', github:'tk-hamaguchi/fluent-plugin-mqtt'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem specific_install -l 'https://github.com/tk-hamaguchi/fluent-plugin-mqtt.git'

## Usage

This client works as ONLY MQTT client.
MQTT topic is set "#".

```

<source>
  type mqtt
  bind 127.0.0.1
  port 1883
</source>

```

Output plugin config.
MQTT topic is set s/\./\//g Fluentd tag

```
<match mqtt.**>
  type mqtt
  bind YOUR_MQTT_BROKERs_IP_OR_DOMAIN
  port YOUR_MQTT_BROKERs_PORT
  username YOUR_MQTT_BROKERs_USERNAME
  password YOUR_MQTT_BROKERs_PASSWORD
</match>
```
