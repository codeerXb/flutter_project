import 'package:event_bus/event_bus.dart';
import './beans/mqtt_bean.dart';
class MqttListenNotifiction {
  late mqtt_model model;
  MqttListenNotifiction(this.model);
}

EventBus eventBus = EventBus();