import 'package:flutter/material.dart';

/// Helper utility for building responsive layouts across Mobile, Tablet, and Desktop web.
class ResponsiveHelper {
  ResponsiveHelper._();

  static const double mobileMaxWidth = 600.0;
  static const double tabletMaxWidth = 1024.0;
  static const double contentMaxConstraintWidth = 720.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileMaxWidth &&
      MediaQuery.of(context).size.width < tabletMaxWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMaxWidth;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
}

/// A wrapper widget that centers content and limits width on wide screens
/// ensuring a clean, app-like visual experience even in wide desktop browsers.
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = ResponsiveHelper.contentMaxConstraintWidth,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= maxWidth) {
      return child;
    }
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
