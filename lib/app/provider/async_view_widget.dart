import 'package:cookiej/app/provider/async_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AsyncViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provider(
        create: (_) => AsyncViewModel(),
        child: Consumer<AsyncViewModel>(builder: (context, vm, _) {
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
        }),
      ),
    );
  }

  Widget buildEmptyWidget(BuildContext context) => Center(
        child: Text('Empty'),
      );

  Widget buildIdleWidget(BuildContext context) => Center(
        child: Text('Idle'),
      );

  Widget buildErrorWidget(BuildContext context) => Center(
        child: Text('Error'),
      );

  Widget buildLoadingWidget(BuildContext context) => Center(
        child: Text('Empty'),
      );

  Widget buildCompleteWidget(BuildContext context) => Center(
        child: Text('Complete'),
      );
}
