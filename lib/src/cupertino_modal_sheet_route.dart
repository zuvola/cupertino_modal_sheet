import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double sheetOffset = 10;
const double displayCornerRadius = 38.5;
const double sheetCornerRadius = 10;
const double scaleFactor = 1 / 12;

class CupertinoModalSheetRoute<T> extends PageRouteBuilder<T> {
  CupertinoModalSheetRoute({
    required this.builder,
    super.settings,
  }) : super(
          pageBuilder: (_, __, ___) => const SizedBox.shrink(),
          opaque: false,
        );

  final RoutePageBuilder builder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    if (!isFirst) {
      final paddingTop = _paddingTop(context);
      return Container(
        decoration:
            const BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12)]),
        child: Padding(
          padding: EdgeInsets.only(top: paddingTop + sheetOffset),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(sheetCornerRadius)),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: builder(context, animation, secondaryAnimation),
            ),
          ),
        ),
      );
    } else {
      return builder(context, animation, secondaryAnimation);
    }
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
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
      final offset = secValue * (paddingTop - dist);
      final scale = 1 - secValue / 12;
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
        transform: Matrix4.identity()
          ..setTranslationRaw(0, offset, 0)
          ..scale(scale),
        alignment: Alignment.topCenter,
        child: child,
      ),
      animation: animation,
      child: child,
    );
  }
}
