import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/widgets/main_layout.dart';
import '../providers/profile_provider.dart';
import '../models/profile_model.dart';
import '../models/profile_settings_model.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return MainLayout(
      activeIndex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingLarge, 32, AppTheme.spacingLarge, 24),
            child: const Center(
              child: Text(
                'Mi Perfil',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
          ),
          Expanded(
            child: profileAsync.when(
              data: (profile) {
                if (profile == null) return const Center(child: Text('Perfil no encontrado'));
                return _buildContent(context, ref, profile);
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ProfileModel profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, profile),
          const SizedBox(height: 32),
          _buildSectionTitle(context, 'Mi Tarjeta de Identificación', Icons.qr_code_2_rounded),
          const SizedBox(height: 16),
          _buildQrCode(context, profile),
          const SizedBox(height: 32),
          _buildSectionTitle(context, 'Datos Personales', Icons.person_rounded),
          const SizedBox(height: 16),
          _buildPersonalInfo(context, profile),
          const SizedBox(height: 32),
          _buildSectionTitle(context, 'Configuración', Icons.settings_rounded),
          const SizedBox(height: 8),
          Text(
            'Preferencias de notificación y acceso a la app',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.neutral500,
                ),
          ),
          const SizedBox(height: 24),
          _buildConfiguration(context, ref, profile),
          const SizedBox(height: 32),
          if (profile.associatedMembers.isNotEmpty) ...[
            _buildSectionTitle(context, 'Asociados', Icons.family_restroom_rounded),
            const SizedBox(height: 16),
            _buildAssociatedMembers(context, profile),
            const SizedBox(height: 32),
          ],
          Builder(
            builder: (context) {
              final bool isMobile = MediaQuery.of(context).size.width < AppTheme.breakpointTablet;
              return SizedBox(height: isMobile ? 120 : 32);
            }
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProfileModel profile) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Text(
              profile.firstName?.isNotEmpty == true ? profile.firstName!.substring(0, 1).toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.fullname,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Membresía: ${profile.entityid}',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCode(BuildContext context, ProfileModel profile) {
    // We generate a QR code with the membership number or ID based on logic.
    final qrData = 'MEMBER:${profile.entityid}:${profile.id}';
    
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200.0,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.circle,
                color: AppTheme.primaryColor,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Escanea este código en los accesos del club.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.neutral500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(BuildContext context, ProfileModel profile) {
    return _buildCard(
      context,
      child: Column(
        children: [
          _buildInfoRow(context, 'Correo electrónico', profile.email ?? 'No registrado', Icons.email_outlined),
          const Divider(height: 32),
          _buildInfoRow(context, 'Teléfono', profile.phone ?? 'No registrado', Icons.phone_outlined),
          const Divider(height: 32),
          _buildInfoRow(context, 'Domicilio de correspondencia', profile.address ?? 'No registrado', Icons.map_outlined),
          const Divider(height: 32),
          _buildInfoRow(
            context,
            'Datos Fiscales',
            'RFC: ${profile.fiscalData?['rfc'] ?? 'N/A'}\n${profile.fiscalData?['address'] ?? 'Sin domicilio fiscal'}',
            Icons.receipt_long_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildConfiguration(BuildContext context, WidgetRef ref, ProfileModel profile) {
    final settings = profile.settings;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.notifications_none_rounded, color: AppTheme.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text('Notificaciones', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        _buildCard(
          context,
          child: Column(
            children: [
              _buildConfigSwitch(
                context,
                title: 'Notificaciones por correo',
                subtitle: 'Recibe avisos de eventos y pagos por email',
                icon: Icons.email_outlined,
                value: settings.emailNotifications,
                onChanged: (val) {
                  ref.read(profileProvider.notifier).updateSettings(settings.copyWith(emailNotifications: val));
                },
              ),
              const Divider(height: 32),
              _buildConfigSwitch(
                context,
                title: 'Notificaciones push',
                subtitle: 'Alertas en tiempo real en tu dispositivo',
                icon: Icons.phone_android_outlined,
                value: settings.pushNotifications,
                onChanged: (val) {
                  ref.read(profileProvider.notifier).updateSettings(settings.copyWith(pushNotifications: val));
                },
              ),
              const Divider(height: 32),
              _buildConfigSwitch(
                context,
                title: 'Recordatorios de clases',
                subtitle: 'Aviso antes de tus clases programadas',
                icon: Icons.notifications_active_outlined,
                value: settings.classReminders,
                onChanged: (val) {
                  ref.read(profileProvider.notifier).updateSettings(settings.copyWith(classReminders: val));
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            const Icon(Icons.shield_outlined, color: AppTheme.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text('Seguridad y Tema', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        _buildCard(
          context,
          child: Column(
            children: [
              _buildConfigSwitch(
                context,
                title: 'Modo Oscuro',
                subtitle: 'Cambiar apariencia de la aplicación',
                icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                value: isDark,
                onChanged: (val) {
                  ref.read(themeProvider.notifier).setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.neutral500.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Las opciones avanzadas de seguridad (cambio de contraseña, autenticación de dos factores, sesiones activas) estarán disponibles próximamente.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.neutral500,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssociatedMembers(BuildContext context, ProfileModel profile) {
    return Column(
      children: profile.associatedMembers.map((member) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCard(
            context,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.neutral200.withOpacity(0.5),
                  child: const Icon(Icons.person, color: AppTheme.neutral500),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.fullname,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${member.memberType} • ${member.membershipNumber}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.neutral500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child, EdgeInsetsGeometry padding = const EdgeInsets.all(AppTheme.spacingLarge)}) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        border: Border.all(color: AppTheme.neutral200.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.neutral500, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.neutral500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfigSwitch(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.neutral500, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.neutral500)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }
}
