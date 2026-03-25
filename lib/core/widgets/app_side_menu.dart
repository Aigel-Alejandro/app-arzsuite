import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/providers/auth_provider.dart';
import 'package:app_arzsuite/core/providers/theme_provider.dart';

class AppIslandMenu extends ConsumerStatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback? onLogout;
  final bool isDesktop;

  const AppIslandMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isDesktop,
    this.onLogout,
  });

  @override
  ConsumerState<AppIslandMenu> createState() => _AppIslandMenuState();
}

class _AppIslandMenuState extends ConsumerState<AppIslandMenu> {
  late int _currentIndex;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  void _handleTap(int index) {
    if (index == _currentIndex || _isNavigating) return;
    
    setState(() {
      _currentIndex = index;
      _isNavigating = true; // Prevent double taps during animation
    });

    // Animate for 350ms before changing the page (Creates a seamless illusion)
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() => _isNavigating = false);
        widget.onItemSelected(index);
      }
    });
  }

  // _showProfileModal removed to navigate directly to ProfileView

  @override
  Widget build(BuildContext context) {
    return widget.isDesktop
        ? _buildDesktopIsland(context)
        : _buildMobileIsland(context);
  }

  Widget _buildDesktopIsland(BuildContext context) {
    return Container(
      width: 64, // ultra-thin for minimalist look
      margin: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32), // stadium shape
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.neutral200.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Clean Logo Icon
          _buildLogoIcon(),
          const SizedBox(height: 40),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _IslandTabItem(
                    icon: Icons
                        .grid_view_rounded, // Matches the reference image style
                    label: 'Inicio',
                    isSelected: _currentIndex == 0,
                    onTap: () => _handleTap(0),
                    isDesktop: true,
                  ),
                  _IslandTabItem(
                    icon: Icons.sports_tennis_rounded,
                    label: 'Actividades',
                    isSelected: _currentIndex == 1,
                    onTap: () => _handleTap(1),
                    isDesktop: true,
                  ),
                  _IslandTabItem(
                    icon: Icons.person_rounded,
                    label: 'Perfil',
                    isSelected: _currentIndex == 2,
                    onTap: () => _handleTap(2),
                    isDesktop: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _IslandTabItem(
            icon: Icons.logout_rounded,
            label: 'Salir',
            isSelected: false,
            isDestructive: true,
            onTap: widget.onLogout ?? () {},
            isDesktop: true,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMobileIsland(BuildContext context) {
    const int totalItems = 4;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      height: 64,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMedium,
        vertical: AppTheme.spacingLarge,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double itemWidth = constraints.maxWidth / totalItems;
          
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(end: _currentIndex.toDouble()),
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            builder: (context, animIndex, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Smooth Custom Painted Background with Moving Notch
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _CurvedBarPainter(
                        index: animIndex,
                        itemWidth: itemWidth,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                  // Floating Background Circle (Moves in perfect sync with the notch)
                  Positioned(
                    left: (animIndex * itemWidth) + (itemWidth / 2) - 24,
                    top: -22,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Normal Tab Content - Wrapped in Positioned.fill for correct ParentData
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          child: _IslandTabItem(
                            icon: Icons.grid_view_rounded,
                            label: 'Inicio',
                            isSelected: _currentIndex == 0,
                            onTap: () => _handleTap(0),
                            isDesktop: false,
                          ),
                        ),
                        Expanded(
                          child: _IslandTabItem(
                            icon: Icons.sports_tennis_rounded,
                            label: 'Actividades',
                            isSelected: _currentIndex == 1,
                            onTap: () => _handleTap(1),
                            isDesktop: false,
                          ),
                        ),
                        Expanded(
                          child: _IslandTabItem(
                            icon: Icons.person_rounded,
                            label: 'Perfil',
                            isSelected: _currentIndex == 2,
                            onTap: () => _handleTap(2),
                            isDesktop: false,
                          ),
                        ),
                        Expanded(
                          child: _IslandTabItem(
                            icon: Icons.logout_rounded,
                            label: 'Salir',
                            isSelected: false,
                            isDestructive: true,
                            onTap: widget.onLogout ?? () {},
                            isDesktop: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLogoIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.layers_rounded,
        color: AppTheme.primaryColor,
        size: 20,
      ),
    );
  }
}

class _IslandTabItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool isDesktop;

  const _IslandTabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDesktop,
    this.isDestructive = false,
  });

  @override
  State<_IslandTabItem> createState() => _IslandTabItemState();
}

class _IslandTabItemState extends State<_IslandTabItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Determine colors based on state
    final Color activeColor = widget.isDestructive
        ? AppTheme.dangerColor
        : AppTheme.primaryColor;
    final Color inactiveColor = AppTheme.neutral500;

    final Color color = widget.isSelected
        ? activeColor
        : (widget.isDestructive && _isHovered
              ? AppTheme.dangerColor
              : inactiveColor);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: widget.isDesktop
          ? _buildDesktopItem(color)
          : _buildMobileItem(context),
    );
  }

  Widget _buildDesktopItem(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8), // Reduced from 12
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: 20,
                color: color,
              ), // Reduced from 22
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _isHovered ? 1.0 : 0.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.label,
                style: TextStyle(
                  color: color,
                  fontSize: 12, // Increased as requested
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileItem(BuildContext context) {
    final Color inactiveColor = AppTheme.neutral500;
    final Color textColor = widget.isSelected
        ? Theme.of(context).colorScheme.onSurface
        : inactiveColor;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          // Icon - Moves UP smoothly to sit inside the floating circle
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            top: widget.isSelected ? -10.0 : 12.0,
            left: 0,
            right: 0,
            child: Center(
              child: Icon(
                widget.icon,
                size: 24,
                color: widget.isSelected ? Colors.white : inactiveColor,
              ),
            ),
          ),
          // Label - Centered at the bottom
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            bottom: widget.isSelected ? 8.0 : 10.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  letterSpacing: -0.2,
                  fontWeight: widget.isSelected
                      ? FontWeight.w800
                      : FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurvedBarPainter extends CustomPainter {
  final double index;
  final double itemWidth;
  final Color color;

  _CurvedBarPainter({
    required this.index,
    required this.itemWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    // 1. Draw the base pill shape
    final RRect hostRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(24.0),
    );
    final Path hostPath = Path()..addRRect(hostRRect);

    // 2. Exact center of the current selected notch
    final double notchCenter = (index * itemWidth) + (itemWidth / 2);

    // Geometry for the bezier notch
    const double notchDepth = 28.0;
    const double notchHalfWidth = 42.0;

    // 3. Draw the notch cut-out shape
    final Path notchPath = Path();
    notchPath.moveTo(notchCenter - 48, 0);
    
    // Left flare corner
    notchPath.quadraticBezierTo(
      notchCenter - 36, 0,
      notchCenter - 29.5, 8,
    );
    
    // Circular gap perfectly encompassing the 48px gold circle
    // The gold circle center is at Y=2 relative to this canvas, with radius 24.
    // This arc uses radius 30, creating a mathematically perfect 6px gap all around.
    notchPath.arcToPoint(
      Offset(notchCenter + 29.5, 8),
      radius: const Radius.circular(30),
      clockwise: false,
    );
    
    // Right flare corner
    notchPath.quadraticBezierTo(
      notchCenter + 36, 0,
      notchCenter + 48, 0,
    ); // Close the polygon upward to subtract the notch completely from the top edge
    notchPath.lineTo(notchCenter + 64, -100);
    notchPath.lineTo(notchCenter - 64, -100);
    notchPath.close();

    // 4. Subtract the notch from the pill
    final Path finalPath = Path.combine(
      PathOperation.difference,
      hostPath,
      notchPath,
    );

    // Draw shadow translated exactly below the bar
    canvas.save();
    canvas.translate(0, 8);
    canvas.drawPath(finalPath, shadowPaint);
    canvas.restore();

    // Draw white bar
    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvedBarPainter oldDelegate) {
    return oldDelegate.index != index || oldDelegate.itemWidth != itemWidth;
  }
}
