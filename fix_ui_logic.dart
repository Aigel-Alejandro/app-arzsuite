              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(
                     dateLabel,
                     style: TextStyle(
                       fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                       fontSize: 13,
                       color: isSelected ? Colors.white : AppTheme.neutral700,
                     ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: AppTheme.neutral100,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  showCheckmark: false,
                  onSelected: (val) {
                    if (val && !isSelected) {
                       setState(() {
                           _activeDayFilters[grupo.id] = wd;
                           _selectedItems.clear(); // Limpiar seleccion de tiempo si cambian de día
                       });
                    }
                  },
                ),
              );
