import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const double sheetOffset = 10;
const double displayCornerRadius = 38.5;
const double sheetCornerRadius = 10;
const double scaleFactor = 1 / 12;
const double breakpointWidth = 800;
const Size maxSize = Size(700, 1000);

enum CupertinoModalSheetRouteTransition {
  none,
  scale,
  fade,
}

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
    required this.barrierDismissible,
    super.settings,
    super.transitionDuration,
    super.reverseTransitionDuration,
    super.barrierLabel,
    super.maintainState = true,
    super.fullscreenDialog = true,
    this.firstTransition = CupertinoModalSheetRouteTransition.none,
  }) : super(
          pageBuilder: (_, __, ___) => const SizedBox.shrink(),
          opaque: false,
          barrierColor: kCupertinoModalBarrierColor,
          barrierDismissible: barrierDismissible,
        );

  /// A builder that builds the widget tree for the [CupertinoModalSheetRoute].
  final WidgetBuilder builder;

  final bool barrierDismissible;

  /// A transition for initial page push animation.
  final CupertinoModalSheetRouteTransition firstTransition;

  Curve _curve = Curves.easeInOut;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final size = MediaQuery.of(context).size;
    final BoxConstraints constrainsts;
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
    } else {
      constrainsts = BoxConstraints(
        minWidth: size.width,
      );
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
              child: _gestureDetector(
                size: size,
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
      var transitionChild =
          _stackTransition(offset, scale, secondaryAnimation, clipChild);
      if (firstTransition == CupertinoModalSheetRouteTransition.fade) {
        transitionChild = FadeTransition(
          opacity: animation,
          child: transitionChild,
        );
      }
      if (firstTransition == CupertinoModalSheetRouteTransition.scale) {
        transitionChild = ScaleTransition(
          scale: animation,
          child: transitionChild,
        );
      }
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: transitionChild,
      );
    }
    if (secondaryAnimation.isDismissed) {
      final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
      final curveTween = CurveTween(curve: _curve);
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

  Widget _gestureDetector({required Widget child, required Size size}) {
    final Function(double velocity) dragEnd;
    dragEnd = (double velocity) {
      final bool animateForward;
      if (velocity.abs() >= 1.0) {
        animateForward = velocity <= 0;
      } else {
        animateForward = (controller?.value ?? 0) > 0.5;
      }
      if (animateForward) {
        controller?.animateTo(1.0,
            duration: transitionDuration, curve: Curves.easeInOut);
      } else {
        navigator?.pop();
      }
      if (controller?.isAnimating ?? false) {
        late AnimationStatusListener animationStatusCallback;
        animationStatusCallback = (AnimationStatus status) {
          navigator?.didStopUserGesture();
          controller?.removeStatusListener(animationStatusCallback);
        };
        controller?.addStatusListener(animationStatusCallback);
      } else {
        if (navigator?.userGestureInProgress ?? false) {
          navigator?.didStopUserGesture();
        }
      }
    };
    return GestureDetector(
      onVerticalDragEnd: (details) {
        dragEnd(details.velocity.pixelsPerSecond.dy / size.width);
      },
      onVerticalDragCancel: () {
        dragEnd(0);
      },
      onVerticalDragStart: (_) {
        navigator?.didStartUserGesture();
      },
      onVerticalDragUpdate: ((details) {
        _curve = Curves.linear;
        controller?.value -= details.delta.dy / size.height;
      }),
      child: child,
    );
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
