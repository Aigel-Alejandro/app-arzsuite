import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/views/login_view.dart';
import 'features/home/views/home_view.dart';
import 'core/providers/global_providers.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await Supabase.initialize(
    url: 'https://jgxwzxqbispwempgetrh.supabase.co',
    anonKey: 'sb_publishable_z3Iw5Cnoy5F7gHViVwZG2A_455RJrPR',
  );

  final prefs = await SharedPreferences.getInstance();

  // En Flutter Web, a veces hay una condición de carrera con el mecanismo de vsync.
  // Un pequeño retraso asegura que el motor JS esté listo antes de montar el ProviderScope.
  await Future.delayed(Duration.zero);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const ArzSuiteApp(),
    ),
  );
}

class ArzSuiteApp extends ConsumerWidget {
  const ArzSuiteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Si el usuario ya está autenticado a nivel de almacenamiento local/Riverpod, lo mandamos a Home.
    final loggedInMember = ref.watch(authProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'App ArzSuite',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'MX'), // Español, México
        Locale('en', 'US'), // Inglés, EUA
      ],
      // Se utiliza el archivo centralizado de colores y componentes (estilo CSS) importando `AppTheme.lightTheme`
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: loggedInMember != null ? const HomeView() : const LoginView(),
    );
  }
}
