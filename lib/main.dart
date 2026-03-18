import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await Supabase.initialize(
    url: 'https://jgxwzxqbispwempgetrh.supabase.co',
    anonKey: 'sb_publishable_z3Iw5Cnoy5F7gHViVwZG2A_455RJrPR',
  );

  // En Flutter Web, a veces hay una condición de carrera con el mecanismo de vsync.
  // Un pequeño retraso asegura que el motor JS esté listo antes de montar el ProviderScope.
  await Future.delayed(Duration.zero);

  runApp(
    const ProviderScope(
      child: ArzSuiteApp(),
    ),
  );
}

class ArzSuiteApp extends ConsumerWidget {
  const ArzSuiteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'App ArzSuite',
      debugShowCheckedModeBanner: false,
      // Se utiliza el archivo centralizado de colores y componentes (estilo CSS) importando `AppTheme.lightTheme`
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginView(),
    );
  }
}
