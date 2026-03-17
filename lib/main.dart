import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await Supabase.initialize(
    url: 'https://jgxwzxqbispwempgetrh.supabase.co',
    anonKey: 'sb_publishable_z3Iw5Cnoy5F7gHViVwZG2A_455RJrPR',
  );

  runApp(
    // ProviderScope es necesario para el manejo de estados e inyección de dependencias con Riverpod
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
      home: const Scaffold(
        body: Center(
          child: Text('ArzSuite Inicializado Exitosamente (Material 3, Riverpod, Supabase)'),
        ),
      ),
    );
  }
}
