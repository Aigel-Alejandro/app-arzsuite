            if (isChecked) {
              _selectedItems.remove(key);
            } else {
              _selectedItems.removeWhere((item) {
                final parts = item.split('-');
                if (parts.length != 2) return false;
                int eqId = int.parse(parts[0]);
                int? hId = parts[1] == 'null' ? null : int.parse(parts[1]);
                return currentSchedules.any(
                  (s) => s['equipo_id'] == eqId && s['horario_id'] == hId,
                );
              });
              _selectedItems.add(key);
            }
