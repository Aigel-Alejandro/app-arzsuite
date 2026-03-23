import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';

class AppIslandMenu extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return isDesktop ? _buildDesktopIsland(context) : _buildMobileIsland(context);
  }

  Widget _buildDesktopIsland(BuildContext context) {
    return Container(
      width: 64, // ultra-thin for minimalist look
      margin: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
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
                    icon: Icons.grid_view_rounded, // Matches the reference image style
                    label: 'Inicio',
                    isSelected: selectedIndex == 0,
                    onTap: () => onItemSelected(0),
                    isDesktop: true,
                  ),
                  _IslandTabItem(
                    icon: Icons.sports_tennis_rounded,
                    label: 'Actividades',
                    isSelected: selectedIndex == 1,
                    onTap: () => onItemSelected(1),
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
            onTap: onLogout ?? () {},
            isDesktop: true,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMobileIsland(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      margin: const EdgeInsets.only(
        left: AppTheme.spacingMedium,
        right: AppTheme.spacingMedium,
        bottom: AppTheme.spacingLarge,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(32), // stadium shape
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppTheme.neutral200.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _IslandTabItem(
            icon: Icons.grid_view_rounded,
            label: 'Inicio',
            isSelected: selectedIndex == 0,
            onTap: () => onItemSelected(0),
            isDesktop: false,
          ),
          _IslandTabItem(
            icon: Icons.sports_tennis_rounded,
            label: 'Actividades',
            isSelected: selectedIndex == 1,
            onTap: () => onItemSelected(1),
            isDesktop: false,
          ),
          _IslandTabItem(
            icon: Icons.logout_rounded,
            label: 'Salir',
            isSelected: false,
            isDestructive: true,
            onTap: onLogout ?? () {},
            isDesktop: false,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
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
    final Color activeColor = widget.isDestructive ? AppTheme.dangerColor : AppTheme.primaryColor;
    final Color inactiveColor = AppTheme.neutral500;
    
    final Color color = widget.isSelected ? activeColor : (widget.isDestructive && _isHovered ? AppTheme.dangerColor : inactiveColor);
    
    Widget content = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: widget.isDesktop ? _buildDesktopItem(color) : _buildMobileItem(color),
    );

    if (!widget.isDesktop) {
      return Expanded(child: content);
    }
    return content;
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, size: 22, color: color),
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
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileItem(Color color) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: widget.isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(24), // Perfectly rounded pill
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 22, color: color),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: widget.isSelected ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
