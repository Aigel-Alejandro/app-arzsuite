import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/app_side_menu.dart';
import 'package:app_arzsuite/features/home/views/home_view.dart';
import 'package:app_arzsuite/features/activities/views/activities_dashboard_view.dart';
import 'package:app_arzsuite/features/profile/views/profile_view.dart';
import 'package:app_arzsuite/features/auth/views/login_view.dart';
import 'package:app_arzsuite/core/providers/auth_provider.dart';
import 'package:app_arzsuite/core/providers/api_client_notifier.dart';

class MainLayout extends ConsumerStatefulWidget {
  final Widget child;
  final int activeIndex;

  const MainLayout({
    super.key,
    required this.child,
    this.activeIndex = 0,
  });

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  void _onItemSelected(int index) {
    if (widget.activeIndex == index) return;
    
    PageRouteBuilder? route;
    if (index == 0) {
      route = PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeView(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
    } else if (index == 1) {
      route = PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ActivitiesDashboardView(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
    } else if (index == 2) {
      route = PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ProfileView(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
    }

    if (route != null) {
      Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
    }
  }

  void _onLogout() {
    // 1. Bloquea la sesión (estado = null) pero no borra credenciales de biometría
    ref.read(authProvider.notifier).lockSession();
    
    // 2. Limpia el token en el cliente HTTP (Dio)
    ref.read(apiClientNotifierProvider.notifier).updateToken('');
    
    // 3. Redirige a login
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= AppTheme.breakpointDesktop;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      bottomNavigationBar: !isDesktop
          ? SafeArea(
              child: AppIslandMenu(
                selectedIndex: widget.activeIndex,
                onItemSelected: _onItemSelected,
                onLogout: _onLogout,
                isDesktop: false,
              ),
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (isDesktop)
              AppIslandMenu(
                selectedIndex: widget.activeIndex,
                onItemSelected: _onItemSelected,
                onLogout: _onLogout,
                isDesktop: true,
              ),
            Expanded(
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
