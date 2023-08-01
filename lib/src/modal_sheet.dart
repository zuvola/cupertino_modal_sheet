import 'package:flutter/widgets.dart';

import '../cupertino_modal_sheet.dart';

/// Shows a modal iOS-style sheet that slides up from the bottom of the screen.
Future<T?> showCupertinoModalSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  bool fullscreenDialog = true,
  bool barrierDismissible = true,
}) {
  return Navigator.of(context, rootNavigator: useRootNavigator).push(
    CupertinoModalSheetRoute<T>(
      builder: builder,
      settings: routeSettings,
      fullscreenDialog: fullscreenDialog,
      barrierDismissible: barrierDismissible,
    ),
  );
}

/// A page that creates a cupertino modal sheet [PageRoute].
class CupertinoModalSheetPage<T> extends Page<T> {
  final Widget child;
  final CupertinoModalSheetRouteTransition firstTransition;

  const CupertinoModalSheetPage({
    super.key,
    required this.child,
    super.name,
    super.arguments,
    super.restorationId,
    this.firstTransition = CupertinoModalSheetRouteTransition.none,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return CupertinoModalSheetRoute<T>(
      builder: (_) => child,
      settings: this,
      firstTransition: firstTransition,
    );
  }
}
