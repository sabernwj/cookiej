import 'package:cookiej/app/provider/async_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AsyncViewWidget<T extends AsyncViewModel> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(builder: (context, vm, _) {
      switch (vm.viewState) {
        case AsyncViewModelState.Error:
          return buildErrorWidget(context);
        case AsyncViewModelState.Loading:
          return buildLoadingWidget(context);
        case AsyncViewModelState.Complete:
          return buildCompleteWidget(context);
        case AsyncViewModelState.Empty:
          return buildEmptyWidget(context);
        default:
          return buildIdleWidget(context);
      }
    });
  }

  Widget buildEmptyWidget(BuildContext context) => Center(
        child: Text('Empty', style: Theme.of(context).textTheme.bodyText1),
      );

  Widget buildIdleWidget(BuildContext context) => Center(
        child: Text('Idle', style: Theme.of(context).textTheme.bodyText1),
      );

  Widget buildErrorWidget(BuildContext context) => Center(
        child: Text('Error', style: Theme.of(context).textTheme.bodyText1),
      );

  Widget buildLoadingWidget(BuildContext context) => Center(
        child: Text('Loading', style: Theme.of(context).textTheme.bodyText1),
      );

  Widget buildCompleteWidget(BuildContext context) => Center(
        child: Text('Complete', style: Theme.of(context).textTheme.bodyText1),
      );
}
