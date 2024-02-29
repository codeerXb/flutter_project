import 'dart:async';

class ListEventBus {
  static ListEventBus? _instance;
  late StreamController _streamController;
  factory ListEventBus.getDefault() {
    _instance ??= ListEventBus._init();
    return _instance!;
    
  }

  ListEventBus._init() {
    _streamController = StreamController.broadcast();
  }

  StreamSubscription register<T>(void Function(T event) onData) {
    ///需要返回订阅者，所以不能使用下面这种形式
//   return _streamController.stream.listen((event) {
//      if (event is T) {
//        onData(event);
//      }
//    });
    ///没有指定类型，全类型注册
    if (T == dynamic) {
      return _streamController.stream.listen(onData as void Function(dynamic event)?);
    } else {
      ///筛选出 类型为 T 的数据,获得只包含T的Stream
      Stream<T> stream =
          _streamController.stream.where((type) => type is T).cast<T>();
      return stream.listen(onData);
    }
  }

  void post(event) {
    _streamController.add(event);
  }

  void unregister() {
    _streamController.close();
  }

  void pause() {
    _streamController.onPause!();
  }

  void resume() {
    _streamController.onResume!();
  }
}
