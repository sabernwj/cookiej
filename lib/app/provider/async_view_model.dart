import 'package:cookiej/app/service/error/app_error.dart';
import 'package:flutter/material.dart';

enum AsyncViewModelState { Loading, Idle, Complete, Empty, Error }

class AsyncViewModel with ChangeNotifier {
  AsyncViewModelState _state;
  AppError _error;

  AsyncViewModelState get viewState => _state;
  AppError get viewError => _error;

  AsyncViewModel() {
    _state = AsyncViewModelState.Idle;
  }

  void changeState(AsyncViewModelState state, {AppError errorInfo}) {
    _state = state ?? _state;
    if (_state == AsyncViewModelState.Error) {
      assert(errorInfo != null);
      _error = errorInfo;
    }
    notifyListeners();
  }
}
