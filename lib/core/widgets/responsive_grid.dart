import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';

/// A simple grid widget that adapts its columns based on screen width.
/// For desktop, it usually displays 3 columns.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double? runSpacing;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = AppTheme.spacingMedium,
    this.runSpacing,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double screenWidth = MediaQuery.of(context).size.width;

        if (screenWidth >= AppTheme.breakpointDesktop) {
          crossAxisCount = desktopColumns;
        } else if (screenWidth >= AppTheme.breakpointTablet) {
          crossAxisCount = tabletColumns;
        } else {
          crossAxisCount = mobileColumns;
        }

        // Using Wrap for desktop columns behavior usually looks better in many cases,
        // but for cards, a GridView or a simple LayoutBuilder + Row is also valid.
        // Let's use a simple Column with Rows if we want it to be part of a scrollable view.
        
        if (crossAxisCount == 1) {
          return Column(
            children: children
                .map((child) => Padding(
                      padding: EdgeInsets.only(bottom: runSpacing ?? spacing),
                      child: child,
                    ))
                .toList(),
          );
        }

        // Split children into rows based on crossAxisCount
        List<List<Widget>> rows = [];
        for (var i = 0; i < children.length; i += crossAxisCount) {
          int end = (i + crossAxisCount < children.length) ? i + crossAxisCount : children.length;
          rows.add(children.sublist(i, end));
        }

        return Column(
          children: rows.asMap().entries.map((entry) {
            int rowIndex = entry.key;
            List<Widget> rowChildren = entry.value;

            return Padding(
              padding: EdgeInsets.only(bottom: rowIndex == rows.length - 1 ? 0 : (runSpacing ?? spacing)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < crossAxisCount; i++)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i == crossAxisCount - 1 ? 0 : spacing),
                        child: i < rowChildren.length ? rowChildren[i] : const SizedBox.shrink(),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
