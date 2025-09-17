import 'package:flutter/widgets.dart';

/// Simple responsive sizing helper based on a reference device size.
///
/// Reference: 375 x 812 (iPhone X logical size)
class Responsive {
  Responsive._(this.context)
    : mediaQuery = MediaQuery.of(context),
      size = MediaQuery.of(context).size,
      textScaleFactor = MediaQuery.of(context).textScaleFactor;

  final BuildContext context;
  final MediaQueryData mediaQuery;
  final Size size;
  final double textScaleFactor;

  static const double _referenceWidth = 375.0;
  static const double _referenceHeight = 812.0;

  /// Obtain a Responsive instance for the provided context.
  static Responsive of(BuildContext context) => Responsive._(context);

  /// Scale a width value relative to screen width.
  double w(double value) => value * size.width / _referenceWidth;

  /// Scale a height value relative to screen height.
  double h(double value) => value * size.height / _referenceHeight;

  /// Scale a font size value, considering textScaleFactor.
  double sp(double value) {
    // Base on width to maintain visual balance; cap extreme textScaleFactor.
    final double widthScaled = w(value);
    final double clampedTextScale = textScaleFactor.clamp(0.9, 1.3);
    return widthScaled * (clampedTextScale / 1.0);
  }

  /// Returns true if device is likely a tablet (>= 600 logical width).
  bool get isTablet => size.width >= 600;
}
