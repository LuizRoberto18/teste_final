import 'dart:async';

///Class to be extended by bloc to simplify call of stream
class StreamBloc<T> {
  final _streamController = StreamController<T>();

  Stream<T> get stream => _streamController.stream;

  bool get isPaused => _streamController.isPaused;

  ///Insert object on stream
  void add(T object) {
    _streamController.add(object);
  }

  ///Insert error on stream
  void addError(Object error) {
    if (!_streamController.isClosed) {
      _streamController.addError(error);
    }
  }

  ///Dispose stream
  void dispose() {
    _streamController.close();
  }
}

///Class to be extended by bloc to simplify call of stream with broadcast
class StreamBlocBroadCast<T> {
  final _streamController = StreamController<T>.broadcast();

  Stream<T> get stream => _streamController.stream;

  ///Insert object on stream
  void add(T object) {
    _streamController.add(object);
  }

  ///Insert error on stream
  void addError(Object error) {
    if (!_streamController.isClosed) {
      _streamController.addError(error);
    }
  }

  ///Dispose stream
  void dispose() {
    _streamController.close();
  }
}
