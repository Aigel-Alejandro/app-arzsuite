import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_provider.dart';
import 'package:app_arzsuite/features/summer_course/models/member.dart';

class Step1SearchTitular extends ConsumerStatefulWidget {
  const Step1SearchTitular({super.key});

  @override
  ConsumerState<Step1SearchTitular> createState() => _Step1SearchTitularState();
}

class _Step1SearchTitularState extends ConsumerState<Step1SearchTitular> {
  final _searchController = TextEditingController();
  List<Member> _searchResults = [];
  bool _isSearching = false;

  void _search() {
    if (_searchController.text.isEmpty) return;
    setState(() => _isSearching = true);
    
    // Mock search logic
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _searchResults = [
            Member(
              id: '1234500',
              membershipNumber: '1234500',
              firstName: 'JOSE ARTURO',
              lastName: 'FEREZ',
              secondLastName: 'VIDAL',
              memberType: 'Titular',
              isTitular: true,
            ),
          ];
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(summerCourseProvider);
    final notifier = ref.read(summerCourseProvider.notifier);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Titular de la Membresía',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.neutral900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Busca al socio titular para comenzar el proceso de inscripción.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.neutral600,
                ),
          ),
          const SizedBox(height: 32),
          
          TextField(
            controller: _searchController,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: 'Número de acción o nombre completo',
              prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor),
              suffixIcon: UnconstrainedBox(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: _search,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          if (_isSearching)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            )
          else if (_searchResults.isNotEmpty) ...[
            Text(
              'RESULTADOS',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neutral500,
                    letterSpacing: 1.1,
                  ),
            ),
            const SizedBox(height: 16),
            ..._searchResults.map((member) {
              final isSelected = state.selectedTitular?.id == member.id;
              
              return GestureDetector(
                onTap: () => notifier.selectTitular(member),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected 
                          ? AppTheme.primaryColor.withOpacity(0.12)
                          : Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          child: const Icon(Icons.person_rounded, 
                            color: AppTheme.primaryColor, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppTheme.neutral900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'No. Acción: ${member.membershipNumber}',
                                style: TextStyle(
                                  color: AppTheme.neutral600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded, 
                            color: AppTheme.secondaryColor, size: 28),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ] else if (_searchController.text.isNotEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(Icons.search_off_rounded, size: 64, color: AppTheme.neutral300),
                  const SizedBox(height: 16),
                  Text(
                    'No se encontraron resultados',
                    style: TextStyle(color: AppTheme.neutral500, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

