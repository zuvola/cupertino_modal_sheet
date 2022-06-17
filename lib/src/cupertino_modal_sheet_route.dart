import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const double sheetOffset = 10;
const double displayCornerRadius = 38.5;
const double sheetCornerRadius = 10;
const double scaleFactor = 1 / 12;
const double breakpointWidth = 800;
const Size maxSize = Size(700, 1000);

/// A route that shows a iOS-style modal sheet that slides up from the
/// bottom of the screen.
///
/// It is used internally by [showCupertinoModalSheet] or can be directly
/// pushed onto the [Navigator] stack to enable state restoration. See
/// [showCupertinoModalSheet] for a state restoration app example.
class CupertinoModalSheetRoute<T> extends PageRouteBuilder<T> {
  /// Creates a page route for use with iOS modal page sheet.
  ///
  /// The values of [builder] must not be null.
  CupertinoModalSheetRoute({
    required this.builder,
    super.settings,
    super.transitionDuration,
    super.reverseTransitionDuration,
    super.barrierLabel,
    super.maintainState = true,
    super.fullscreenDialog = true,
  }) : super(
          pageBuilder: (_, __, ___) => const SizedBox.shrink(),
          opaque: false,
          barrierColor: kCupertinoModalBarrierColor,
          barrierDismissible: true,
        );

  /// A builder that builds the widget tree for the [CupertinoModalSheetRoute].
  final WidgetBuilder builder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final size = MediaQuery.of(context).size;
    var constrainsts = const BoxConstraints();
    var borderRadius =
        const BorderRadius.vertical(top: Radius.circular(sheetCornerRadius));
    if (size.width > breakpointWidth) {
      if (isFirst) {
        return builder(context);
      }
      constrainsts = BoxConstraints(
          maxWidth: maxSize.width,
          maxHeight: min(size.height * 0.9, maxSize.height));
      borderRadius = const BorderRadius.all(Radius.circular(sheetCornerRadius));
    }
    if (isFirst) {
      return builder(context);
    } else {
      final paddingTop = _paddingTop(context);
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: paddingTop + sheetOffset),
          child: CupertinoUserInterfaceLevel(
            data: CupertinoUserInterfaceLevelData.elevated,
            child: ConstrainedBox(
              constraints: constrainsts,
              child: ClipRRect(
                borderRadius: borderRadius,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: builder(context),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.of(context).size.width > breakpointWidth) {
      if (isFirst) {
        return child;
      }
    }
    final secValue = secondaryAnimation.value;
    final paddingTop = _paddingTop(context);
    if (isFirst) {
      final offset = secValue * paddingTop;
      final scale = 1 - secValue * scaleFactor;
      final r = paddingTop > 30 ? displayCornerRadius : 0.0;
      final radius = r - secValue * (r - sheetCornerRadius);
      final clipChild = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: child,
      );
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: _stackTransition(offset, scale, secondaryAnimation, clipChild),
      );
    }
    if (secondaryAnimation.isDismissed) {
      final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
      final curveTween = CurveTween(curve: Curves.easeInOut);
      return SlideTransition(
        position: animation.drive(curveTween).drive(tween),
        child: child,
      );
    } else {
      final dist = (paddingTop + sheetOffset) * (1 - scaleFactor);
      final double offset = secValue * (paddingTop - dist);
      final scale = 1 - secValue * scaleFactor;
      return _stackTransition(offset, scale, secondaryAnimation, child);
    }
  }

  double _paddingTop(BuildContext context) {
    var paddingTop = MediaQuery.of(context).padding.top;
    if (paddingTop <= 20) {
      paddingTop += 10;
    }
    return paddingTop;
  }

  Widget _stackTransition(
      double offset, double scale, Animation<double> animation, Widget child) {
    return AnimatedBuilder(
      builder: (context, child) => Transform(
        transform: Matrix4.translationValues(0, offset, 0)..scale(scale),
        alignment: Alignment.topCenter,
        child: child,
      ),
      animation: animation,
      child: child,
    );
  }
}
