import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';
import 'package:app_arzsuite/features/activities/views/child_detail_profile_view.dart';
import 'package:app_arzsuite/features/activities/views/activities_list_view.dart';

class ChildSelectorView extends StatelessWidget {
  const ChildSelectorView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      activeIndex: 1,
      child: Scaffold(
        backgroundColor: AppTheme.neutral50,
        appBar: AppBar(
          title: const Text('Comunidad Familiar', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppTheme.neutral900,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ResponsiveContainer(
            padding: AppTheme.spacingLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 // Header Message (Sin animaciones)
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      Text(
                       'Seleccione un Expediente',
                       style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                             fontWeight: FontWeight.w900,
                             color: AppTheme.neutral900,
                             letterSpacing: -1,
                           ),
                     ),
                     const SizedBox(height: 8),
                     Text(
                       'Accede a torneos, actividades y fichas médicas de cada integrante.',
                       style: TextStyle(color: AppTheme.neutral500, fontSize: 16),
                     ),
                   ],
                 ),
                
                const SizedBox(height: AppTheme.spacingLarge * 1.5),
                
                _ChildSelectorCardPremium(
                  name: 'Juanito Pérez',
                  activitiesCount: 2,
                  imageAsset: null,
                  iconData: Icons.face_rounded,
                  delayMs: 100,
                  onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const ChildDetailProfileView(childName: 'Juanito Pérez'), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero)),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                _ChildSelectorCardPremium(
                  name: 'María Pérez',
                  activitiesCount: 1,
                  imageAsset: null,
                  iconData: Icons.face_3_rounded,
                  delayMs: 250,
                  onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const ChildDetailProfileView(childName: 'María Pérez'), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero)),
                ),
                
                const SizedBox(height: AppTheme.spacingLarge * 2),
                 SizedBox(
                   width: double.infinity,
                   child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const ActivitiesListView(isSubscribed: false), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero)),
                    icon: const Icon(Icons.search_rounded, size: 20),
                    label: const Text('Explorar Catálogo de Actividades', style: TextStyle(fontWeight: FontWeight.w900)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium)),
                    ),
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

class _ChildSelectorCardPremium extends StatefulWidget {
  final String name;
  final int activitiesCount;
  final String? imageAsset;
  final IconData iconData;
  final VoidCallback onTap;
  final int delayMs; // for staggered animation

  const _ChildSelectorCardPremium({
    required this.name,
    required this.activitiesCount,
    this.imageAsset,
    required this.iconData,
    required this.onTap,
    required this.delayMs,
  });

  @override
  State<_ChildSelectorCardPremium> createState() => _ChildSelectorCardPremiumState();
}

class _ChildSelectorCardPremiumState extends State<_ChildSelectorCardPremium> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _isHovered ? 1.03 : 1.0,
      child: InkWell(
        onHover: (v) => setState(() => _isHovered = v),
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
            border: Border.all(color: _isHovered ? AppTheme.primaryColor.withValues(alpha: 0.2) : AppTheme.neutral100, width: 2),
            boxShadow: [
               BoxShadow(
                 color: _isHovered ? AppTheme.primaryColor.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.04),
                 blurRadius: _isHovered ? 25 : 10,
                 offset: Offset(0, _isHovered ? 12 : 5),
               )
            ],
          ),
          child: Row(
            children: [
              // Minimalist Avatar
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.iconData, color: AppTheme.primaryColor, size: 36),
              ),
              const SizedBox(width: AppTheme.spacingLarge),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.neutral900)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.vibrantGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                         '${widget.activitiesCount} ACTIVIDADE${widget.activitiesCount > 1 ? 'S' : ''}', 
                         style: const TextStyle(fontSize: 11, color: Color(0xFF9C842B), fontWeight: FontWeight.w900, letterSpacing: 1.2),
                      ),
                    )
                  ],
                ),
              ),
              // Arrow
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isHovered ? AppTheme.primaryColor : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded, 
                  color: _isHovered ? Colors.white : AppTheme.neutral300, 
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
