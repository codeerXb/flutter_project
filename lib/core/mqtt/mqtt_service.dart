import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart';
import "package:flutter_template/config/base_config.dart";

Future<MqttClient> connect() async {
  debugPrint('------------------执行到这里了---------------');
  MqttServerClient client = MqttServerClient.withPort(
    BaseConfig.mqttMainUrl, 'flutter_client', BaseConfig.websocketPort);
  // client.logging(on: true);
  client.useWebSocket = true;
  client.autoReconnect = true;
  client.keepAlivePeriod = 60;
  // client.connectTimeoutPeriod = 5000;
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onUnsubscribed = onUnsubscribed;
  client.onSubscribed = onSubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;

  final connMess = MqttConnectMessage()
      .authenticateAs('admin', 'smawav')
      .withWillTopic('willtopic')
      .withWillMessage('My Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);
  client.connectionMessage = connMess;
  try {
    debugPrint('Connecting');
    await client.connect();
  } catch (e) {
    debugPrint('Exception: $e');
    client.disconnect();
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    debugPrint('EMQX client connected');
    // client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    //   final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
    //   final payload =
    //       MqttPublishPayload.bytesToStringAsString(message.payload.message);

    //   debugPrint('Received message:$payload from topic: ${c[0].topic}>');
    // });

    client.published!.listen((MqttPublishMessage message) {
      debugPrint('published');
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      debugPrint(
          'Published message: $payload to topic: ${message.variableHeader!.topicName}');
    });
  } else {
    debugPrint(
        'EMQX client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    // exit(-1);
  }

  return client;
}

void onConnected() {
  debugPrint('Connected');
}

void onDisconnected() {
  debugPrint('Disconnected');
}

void onSubscribed(String topic) {
  debugPrint('Subscribed topic: $topic');
}

void onSubscribeFail(String topic) {
  debugPrint('Failed to subscribe topic: $topic');
}

void onUnsubscribed(String? topic) {
  debugPrint('Unsubscribed topic: $topic');
}

void pong() {
  debugPrint('Ping response client callback invoked');
}
