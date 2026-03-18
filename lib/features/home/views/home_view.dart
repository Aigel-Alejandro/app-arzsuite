import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/features/summer_course/views/summer_course_wizard_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecosistema Centro Libanés'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido al Ecosistema',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Selecciona una opción para continuar:'),
            const SizedBox(height: 30),
            
            // Summer Course Registration Card
            _FeatureCard(
              title: 'Cursos de Verano 2026',
              description: 'Inscribe a tus beneficiarios e invitados al próximo curso de verano.',
              icon: Icons.sunny,
              color: Colors.orange.shade700,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SummerCourseWizardView()),
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // Placeholder for other features
            _FeatureCard(
              title: 'Próximamente',
              description: 'Más servicios digitales para socios próximamente.',
              icon: Icons.more_horiz,
              color: Colors.grey,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 5),
                    Text(description, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
