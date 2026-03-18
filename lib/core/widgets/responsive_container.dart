import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';

/// A widget that mimics a Bootstrap container, centering content and
/// limiting its width based on screen size.
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final bool fluid;
  final double? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.fluid = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (fluid) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding ?? AppTheme.spacingLarge),
        child: child,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth;
        double screenWidth = constraints.maxWidth;

        if (screenWidth >= AppTheme.breakpointLargeDesktop) {
          maxWidth = AppTheme.containerMaxWidthLargeDesktop;
        } else if (screenWidth >= AppTheme.breakpointDesktop) {
          maxWidth = AppTheme.containerMaxWidthDesktop;
        } else if (screenWidth >= AppTheme.breakpointTablet) {
          maxWidth = AppTheme.containerMaxWidthTablet;
        } else {
          // Mobile: Use full width with padding
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding ?? AppTheme.spacingLarge),
            child: child,
          );
        }

        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: EdgeInsets.symmetric(horizontal: padding ?? AppTheme.spacingLarge),
            child: child,
          ),
        );
      },
    );
  }
}
