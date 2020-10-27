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
              return buildErrorWidget();
            case AsyncViewModelState.Loading:
              return buildLoadingWidget();
            default:
              return buildIdleWidget();
          }
        }),
      ),
    );
  }

  Widget buildEmptyWidget() => Container();

  Widget buildIdleWidget() => Container();

  Widget buildErrorWidget() => Container();

  Widget buildLoadingWidget() => Container();

  Widget buildCompleteWidget() => Container();
}
