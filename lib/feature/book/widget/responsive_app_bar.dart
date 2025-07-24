// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gen/gen.dart';

/// A responsive app bar that adapts to different screen sizes.
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a new instance of [ResponsiveAppBar].
  const ResponsiveAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isTablet = screenWidth >= 768;
        final isMobile = screenWidth < 768;

        final toolbarHeight = isTablet ? 100.0 : 80.0;
        final logoSize = isTablet ? 56.0 : 48.0;
        final horizontalPadding = isTablet ? 24.0 : 16.0;
        final borderRadius = isTablet ? 24.0 : 18.0;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            toolbarHeight: toolbarHeight,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: isMobile ? 200 : 240,
            leading: Padding(
              padding: EdgeInsets.only(left: horizontalPadding, bottom: 8),
              child: Assets.icons.logo.svg(
                package: 'gen',
                width: logoSize * 0.7,
                height: logoSize * 0.7,
                fit: BoxFit.scaleDown,
                // colorFilter: const ColorFilter.mode(
                //   Colors.white,
                //   BlendMode.srcIn,
                // ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}
