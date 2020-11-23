import 'package:cookiej/app/provider/async_view_model.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AsyncViewWidget<T extends AsyncViewModel> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(builder: (context, vm, _) {
      switch (vm.viewState) {
        case AsyncViewModelState.Error:
          if (vm.viewError.errorType == AppErrorType.AuthorizationError) {
            // 此处发生token失效错误，跳转到处理用用户组的页面
          }
          return buildErrorWidget(context, vm);
        case AsyncViewModelState.Loading:
          return buildLoadingWidget(context, vm);
        case AsyncViewModelState.Complete:
          return buildCompleteWidget(context, vm);
        case AsyncViewModelState.Empty:
          return buildEmptyWidget(context, vm);
        default:
          return buildIdleWidget(context, vm);
      }
    });
  }

  Widget buildEmptyWidget(BuildContext context, T vm) => Center(
        child: Text('Empty', style: Theme.of(context).textTheme.bodyText1),
      );

  Widget buildIdleWidget(BuildContext context, T vm) => Center(
        child: Text('Idle', style: Theme.of(context).textTheme.bodyText1),
      );

  Widget buildErrorWidget(BuildContext context, T vm) => Center(
        child: Text('Error', style: Theme.of(context).textTheme.bodyText1),
      );

  Widget buildLoadingWidget(BuildContext context, T vm) => Center(
        child: Text('Loading', style: Theme.of(context).textTheme.bodyText1),
      );

  Widget buildCompleteWidget(BuildContext context, T vm) => Center(
        child: Text('Complete', style: Theme.of(context).textTheme.bodyText1),
      );
}
