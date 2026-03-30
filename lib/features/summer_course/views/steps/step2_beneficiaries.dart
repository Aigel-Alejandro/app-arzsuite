import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_provider.dart';

class Step2Beneficiaries extends ConsumerWidget {
  const Step2Beneficiaries({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(summerCourseProvider);
    final notifier = ref.read(summerCourseProvider.notifier);

    final titular = state.selectedTitular;
    if (titular == null) {
      return const Center(child: Text('Selecciona un titular primero'));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.neutral100 : AppTheme.neutral900;
    final subtitleColor = isDark ? AppTheme.neutral400 : AppTheme.neutral600;
    final cardBgColor = isDark ? AppTheme.neutral800 : Colors.white;
    final borderColor = isDark
        ? AppTheme.neutral700
        : AppTheme.neutral200.withOpacity(0.8);
    final altBgColor = isDark
        ? AppTheme.neutral800.withOpacity(0.5)
        : AppTheme.neutral100;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLarge,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titular Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.primaryColor,
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titular.fullName
                            .replaceAll(RegExp(r'[0-9]'), '')
                            .trim(),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Acción: ${titular.membershipNumber} • SOCIO TITULAR',
                        style: const TextStyle(
                          color: AppTheme.neutral500,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Text(
            'Beneficiarios Directos',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona a los miembros de la familia que participarán (Rango: 3 a 15 años):',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: subtitleColor, height: 1.4),
          ),

          const SizedBox(height: 24),

          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.beneficiariesList.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  'No hay beneficiarios registrados bajo esta acción.',
                ),
              ),
            )
          else ...[
            ...state.beneficiariesList
                .where((b) {
                  final isWithinAgeRange =
                      b.age != null && b.age! >= 3 && b.age! <= 15;
                  return isWithinAgeRange;
                })
                .map((beneficiary) {
                  final activeReg = state.activeRegistration;
                  final registeredSociosRaw = activeReg?['registered_socios'];
                  final registeredSociosList = registeredSociosRaw != null
                      ? (registeredSociosRaw as List)
                            .map((e) => e.toString())
                            .toList()
                      : [];

                  final registeredSociosWeeksRaw =
                      activeReg?['registered_socios_weeks'];
                  final Map<String, List<int>> registeredSociosWeeks = {};
                  if (registeredSociosWeeksRaw != null &&
                      registeredSociosWeeksRaw is Map) {
                    registeredSociosWeeksRaw.forEach((k, v) {
                      registeredSociosWeeks[k.toString()] = (v as List)
                          .map((e) => int.tryParse(e.toString()) ?? 0)
                          .toList();
                    });
                  }

                  final isAlreadyRegistered = registeredSociosList.contains(
                    beneficiary.id,
                  );
                  final canSelect = true; // Permitimos la re-inscripción

                  final isSelected = state.selectedParticipants.any(
                    (p) => p.member?.id == beneficiary.id,
                  );

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isAlreadyRegistered
                          ? AppTheme.successColor.withOpacity(
                              isDark ? 0.05 : 0.02,
                            )
                          : cardBgColor,
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadiusMedium,
                      ),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : (isAlreadyRegistered
                                  ? AppTheme.successColor.withOpacity(0.3)
                                  : borderColor),
                      ),
                      boxShadow: [
                        if (!isAlreadyRegistered && !isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: InkWell(
                      onTap: canSelect
                          ? () => notifier.toggleBeneficiary(beneficiary)
                          : null,
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadiusMedium,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: isSelected
                                  ? AppTheme.primaryColor.withOpacity(0.1)
                                  : (isAlreadyRegistered
                                        ? AppTheme.successColor.withOpacity(0.1)
                                        : (isDark
                                              ? AppTheme.neutral700
                                              : AppTheme.neutral50)),
                              child: Icon(
                                isSelected
                                    ? Icons.check_circle_rounded
                                    : (isAlreadyRegistered
                                          ? Icons.refresh_rounded
                                          : Icons.person_outline_rounded),
                                size: 18,
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : (isAlreadyRegistered
                                          ? AppTheme.successColor
                                          : (isDark
                                                ? AppTheme.neutral300
                                                : AppTheme.neutral400)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${beneficiary.fullName}  ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            height: 1.3,
                                            color: isAlreadyRegistered
                                                ? AppTheme.successColor
                                                : (isSelected
                                                      ? AppTheme.primaryColor
                                                      : textColor),
                                            decoration: null,
                                          ),
                                        ),
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? AppTheme.neutral700
                                                  : AppTheme.neutral100,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              beneficiary.memberType,
                                              style: TextStyle(
                                                color: isDark
                                                    ? AppTheme.neutral300
                                                    : AppTheme.neutral600,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 4,
                                    children: [
                                      Text(
                                        'No. Credencial: ${beneficiary.membershipNumber}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.neutral500,
                                        ),
                                      ),
                                      Text(
                                        'Edad: ${beneficiary.age != null ? '${beneficiary.age} años' : 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.neutral500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isAlreadyRegistered) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Semanas inscritas: ${registeredSociosWeeks[beneficiary.id]?.join(", ") ?? "N/A"} (Puedes agregar más)',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.successColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (canSelect) ...[
                              const SizedBox(width: 12),
                              Checkbox(
                                value: isSelected,
                                onChanged: (_) =>
                                    notifier.toggleBeneficiary(beneficiary),
                                activeColor: AppTheme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: BorderSide(
                                  color: isDark
                                      ? AppTheme.neutral500
                                      : AppTheme.neutral300,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),

            const SizedBox(height: 24),

            // ACORDEÓN PARA MIEMBROS FUERA DE RANGO DE EDAD
            Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                iconColor: AppTheme.neutral500,
                title: Text(
                  'OTROS FAMILIARES (NO APLICAN)',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neutral500,
                    letterSpacing: 1.1,
                  ),
                ),
                children: [
                  ...state.beneficiariesList
                      .where((b) {
                        final isWithinAgeRange =
                            b.age != null && b.age! >= 3 && b.age! <= 15;
                        return !isWithinAgeRange;
                      })
                      .map((b) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: altBgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                color: AppTheme.neutral400,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${b.fullName}  ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.neutral600,
                                              fontSize: 13,
                                              height: 1.3,
                                            ),
                                          ),
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.middle,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? AppTheme.neutral700
                                                    : AppTheme.neutral200,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                b.memberType,
                                                style: TextStyle(
                                                  color: isDark
                                                      ? AppTheme.neutral300
                                                      : AppTheme.neutral600,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      b.age == null
                                          ? 'Edad no registrada'
                                          : 'Edad: ${b.age} años (Solo de 3 a 15)',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.neutral500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: altBgColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              border: isDark ? Border.all(color: AppTheme.neutral700) : null,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppTheme.neutral600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${state.selectedParticipants.where((p) => p.isSocio).length} familiares seleccionados para inscripción.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
