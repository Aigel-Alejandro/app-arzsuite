import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchResults = [
            Member(
              id: '1234500',
              membershipNumber: '1234500',
              firstName: 'JOSE',
              lastName: 'FEREZ',
              secondLastName: 'VIDAL',
              memberType: '1',
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Búsqueda de Socio Titular',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('Ingresa el número de membresía o nombre del socio*'),
          const SizedBox(height: 20),
          
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Ej. 22706 o Jose Perez',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _search,
              ),
            ),
            onSubmitted: (_) => _search(),
          ),
          
          const SizedBox(height: 30),
          
          if (_isSearching)
            const Center(child: CircularProgressIndicator())
          else if (_searchResults.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final member = _searchResults[index];
                final isSelected = state.selectedTitular?.id == member.id;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: isSelected ? 4 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: isSelected 
                      ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                      : BorderSide.none,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: const Icon(Icons.person),
                    ),
                    title: Text(member.fullName),
                    subtitle: Text('ID: ${member.membershipNumber} • Titular'),
                    trailing: isSelected 
                      ? const Icon(Icons.check_circle, color: Colors.green) 
                      : null,
                    onTap: () => notifier.selectTitular(member),
                  ),
                );
              },
            )
          else if (_searchController.text.isNotEmpty)
            const Center(child: Text('No se encontraron socios')),
        ],
      ),
    );
  }
}
