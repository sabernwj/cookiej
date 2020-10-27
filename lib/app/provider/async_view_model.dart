import 'package:flutter/material.dart';

enum AsyncViewModelState { Loading, Idle, Complete, Empty, Error }

class AsyncViewModel with ChangeNotifier {
  AsyncViewModelState _state;

  AsyncViewModelState get viewState => _state;

  AsyncViewModel() {
    _state = AsyncViewModelState.Idle;
  }

  void changeState(AsyncViewModelState state) {
    _state = state ?? _state;
    notifyListeners();
  }
}
