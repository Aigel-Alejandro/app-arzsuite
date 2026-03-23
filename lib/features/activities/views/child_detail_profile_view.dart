import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';
import 'package:app_arzsuite/features/activities/views/activities_list_view.dart';
import 'package:app_arzsuite/features/activities/views/child_medical_form_view.dart';
import 'package:app_arzsuite/features/activities/views/match_detail_view.dart';
import 'package:app_arzsuite/features/activities/widgets/premium_horizontal_calendar.dart';

class ChildDetailProfileView extends StatelessWidget {
  final String childName;

  const ChildDetailProfileView({super.key, required this.childName});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      activeIndex: 1,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: AppTheme.neutral50,
          appBar: AppBar(
            title: Text(
               childName,
               style: const TextStyle(
                 fontWeight: FontWeight.w900, 
                 fontSize: 22, 
                 letterSpacing: -0.5,
               ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: const Color(0xFFFDFDFD),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppTheme.borderRadiusGlobal),
              ),
            ),
            bottom: const TabBar(
              indicatorColor: Color(0xFFFDFDFD),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 4,
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w900, 
                fontSize: 12, 
                letterSpacing: 0.8,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600, 
                fontSize: 12,
              ),
              unselectedLabelColor: Color(0x99FDFDFD),
              labelColor: Color(0xFFFDFDFD),
              tabs: [
                Tab(text: 'ACTIVIDADES'),
                Tab(text: 'TORNEOS'),
                Tab(text: 'EXPEDIENTE'),
              ],
            ),
          ),
          body: const TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              ActivitiesListView(isSubscribed: true, useLayout: false),
              _TournamentsTabPremium(),
              ChildMedicalFormView(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TournamentsTabPremium extends StatefulWidget {
  const _TournamentsTabPremium();

  @override
  State<_TournamentsTabPremium> createState() => _TournamentsTabPremiumState();
}

class _TournamentsTabPremiumState extends State<_TournamentsTabPremium> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      children: [
        Text(
          'Agendar y Calendario',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.neutral900),
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        
        // Interactive Calendar
        PremiumHorizontalCalendar(onDateSelected: (day) {}),
        
        const SizedBox(height: AppTheme.spacingLarge),
        const Divider(height: 32, color: AppTheme.neutral200),
        
        Text(
          'Próximos Encuentros',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.neutral900),
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        
        _InteractiveMatchCard(
          title: 'Jornada 5 vs Club X',
          date: 'Sábado 21, 10:00 AM',
          location: 'Cancha Central',
          onTap: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const MatchDetailView(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero));
          },
        ),
      ],
    );
  }
}

class _InteractiveMatchCard extends StatefulWidget {
  final String title;
  final String date;
  final String location;
  final VoidCallback onTap;

  const _InteractiveMatchCard({
    required this.title, 
    required this.date, 
    required this.location, 
    required this.onTap
  });

  @override
  State<_InteractiveMatchCard> createState() => _InteractiveMatchCardState();
}

class _InteractiveMatchCardState extends State<_InteractiveMatchCard> {
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
               border: Border.all(color: _isHovered ? AppTheme.primaryColor.withValues(alpha: 0.3) : AppTheme.neutral100, width: 2),
               boxShadow: [
                  BoxShadow(
                    color: _isHovered ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                    blurRadius: _isHovered ? 25 : 8,
                    offset: Offset(0, _isHovered ? 12 : 4),
                  )
               ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                  child: const Icon(Icons.sports_soccer_rounded, color: AppTheme.primaryColor, size: 32),
                ),
                const SizedBox(width: AppTheme.spacingLarge),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(widget.date, style: const TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                         children: [
                           const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.neutral500),
                           const SizedBox(width: 4),
                           Text(widget.location, style: const TextStyle(color: AppTheme.neutral500, fontSize: 13, fontWeight: FontWeight.w600)),
                         ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.neutral50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppTheme.neutral400),
                )
              ],
            ),
        ),
      ),
    );
  }
}
