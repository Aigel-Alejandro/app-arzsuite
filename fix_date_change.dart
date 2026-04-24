                  onSelected: (val) {
                    if (val && !isSelected) {
                      setState(() {
                        _activeDayFilters[grupo.id] = wd;
                        // Limpiar los horarios seleccionados si el usuario cambia el día
                        _selectedItems.clear();
                      });
                    }
                  },
