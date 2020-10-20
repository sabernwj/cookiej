import 'package:flutter/material.dart';

enum AsyncViewModelState { loading, idle, complete, empty, error }

class AsyncViewModel with ChangeNotifier {
  AsyncViewModelState _state;

  AsyncViewModelState get viewState => _state;

  AsyncViewModel() {
    _state = AsyncViewModelState.idle;
  }

  void changeState(AsyncViewModelState state) {
    _state = state ?? _state;
    notifyListeners();
  }
}
