import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveUtils {
  // Device breakpoints
  static const double mobileMaxWidth = 768;
  static const double tabletMaxWidth = 1024;

  // Check device types
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileMaxWidth;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileMaxWidth &&
        MediaQuery.of(context).size.width < tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletMaxWidth;
  }

  // Quick access using Get
  static bool get isMobileDevice => Get.width < mobileMaxWidth;
  static bool get isTabletDevice => Get.width >= mobileMaxWidth && Get.width < tabletMaxWidth;
  static bool get isDesktopDevice => Get.width >= tabletMaxWidth;

  // Responsive values
  static double getResponsivePadding(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 40.0;
  }

  static double getResponsiveFontSize(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static int getResponsiveGridCount(BuildContext context, {
    required int mobile,
    required int tablet,
    required int desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Quick responsive widgets
  static Widget responsiveContainer({
    required Widget child,
    EdgeInsets? mobilePadding,
    EdgeInsets? tabletPadding,
    EdgeInsets? desktopPadding,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        EdgeInsets padding;
        if (isMobile(context)) {
          padding = mobilePadding ?? const EdgeInsets.all(16);
        } else if (isTablet(context)) {
          padding = tabletPadding ?? const EdgeInsets.all(24);
        } else {
          padding = desktopPadding ?? const EdgeInsets.all(40);
        }
        
        return Container(
          padding: padding,
          child: child,
        );
      },
    );
  }

  // Get safe area padding for mobile
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }
}
