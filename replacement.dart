  List<Widget> _buildHorarioLevelRadios(ActivityGroupModel grupo, bool isFull) {
    if (grupo.equipos.isEmpty) return [];

    if (_selectedGroupId == null && widget.activity.grupos.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedGroupId = grupo.id);
      });
    }

    Map<int, List<Map<String, dynamic>>> schedulesByDay = {}; // keyed by diaSemana
    bool hasSchedules = false;
    for (var equipo in grupo.equipos) {
      if (equipo.horarios.isEmpty) continue;
      for (var horario in equipo.horarios) {
        hasSchedules = true;
        int day = horario.diaSemana;
        schedulesByDay.putIfAbsent(day, () => []);
        schedulesByDay[day]!.add({
          'equipo_id': equipo.id,
          'horario_id': horario.id,
          'hora_inicio': horario.horaInicio,
          'hora_fin': horario.horaFin,
          'tiene_cupo': horario.tieneCupo,
          'cupo_disponible': horario.cupoDisponible,
        });
      }
    }

    if (!hasSchedules) return [];

    // Map `diaSemana` to upcoming dates (next 7 days)
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> upcomingDates = [];
    
    for (int i = 0; i < 7; i++) {
      DateTime targetDate = now.add(Duration(days: i));
      int targetWeekday = targetDate.weekday; // 1 = Mon, 7 = Sun
      
      if (schedulesByDay.containsKey(targetWeekday)) {
        // filter out passed times if it's today
        List<Map<String, dynamic>> validSchedules = [];
        for (var sched in schedulesByDay[targetWeekday]!) {
          bool hasPassed = false;
          if (i == 0) {
            try {
              final parts = sched['hora_inicio'].split(':');
              final schedTime = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
              if (schedTime.isBefore(now)) {
                hasPassed = true;
              }
            } catch (_) {}
          }
          if (!hasPassed) {
             validSchedules.add(sched);
          }
        }
        
        if (validSchedules.isNotEmpty) {
           upcomingDates.add({
             'date': targetDate,
             'weekday': targetWeekday,
             'schedules': validSchedules,
             'dateStr': '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}'
           });
        }
      }
    }

    if (upcomingDates.isEmpty) {
       return [
         const Padding(
           padding: EdgeInsets.all(16.0),
           child: Text(
             "No hay clases disponibles en los próximos 7 días.",
             style: TextStyle(color: AppTheme.neutral500),
           ),
         )
       ];
    }
    
    // Set initial active date string to first available if not set
    if (!_activeDayFilters.containsKey(grupo.id)) {
      _activeDayFilters[grupo.id] = upcomingDates.first['weekday'];
    }
    
    int currentWeekday = _activeDayFilters[grupo.id]!;
    // verify the current weekday still exists in valid upcoming dates
    if (!upcomingDates.any((d) => d['weekday'] == currentWeekday)) {
       currentWeekday = upcomingDates.first['weekday'];
       _activeDayFilters[grupo.id] = currentWeekday;
    }

    final activeDateObj = upcomingDates.firstWhere((d) => d['weekday'] == currentWeekday);
    List<Map<String, dynamic>> currentSchedules = activeDateObj['schedules'];
    currentSchedules.sort((a, b) => (a['hora_inicio'] as String).compareTo(b['hora_inicio'] as String));

    List<Widget> children = [];

    // Horizontal Scrollable Day Selector (Pills)
    children.add(
      Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: upcomingDates.map((dateObj) {
              DateTime d = dateObj['date'];
              int wd = dateObj['weekday'];
              final isSelected = currentWeekday == wd;
              
              String dateLabel = "";
              if (d.year == now.year && d.month == now.month && d.day == now.day) {
                dateLabel = "Hoy, ${_shortDia(wd)} ${d.day}";
              } else if (d.year == now.year && d.month == now.month && d.day == now.add(const Duration(days: 1)).day) {
                dateLabel = "Mañana, ${_shortDia(wd)} ${d.day}";
              } else {
                List<String> months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
                dateLabel = "${_shortDia(wd)} ${d.day} de ${months[d.month - 1]}";
              }

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
                    if (val) {
                       setState(() => _activeDayFilters[grupo.id] = wd);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );

    List<Widget> chips = currentSchedules.map((sched) {
      final key = "${sched['equipo_id']}-${sched['horario_id']}";
      final isChecked = _selectedItems.contains(key);
      final timeStr = "${(sched['hora_inicio'] as String).substring(0, 5)} - ${(sched['hora_fin'] as String).substring(0, 5)} hrs";

      final bool tieneCupo = sched['tiene_cupo'] as bool? ?? false;
      final int? cupoDisp = sched['cupo_disponible'] as int?;
      final bool isHorarioFull = tieneCupo && cupoDisp != null && cupoDisp <= 0;
      final bool isDisabled = isFull || isHorarioFull;

      return InkWell(
        onTap: isDisabled ? null : () {
          setState(() {
            if (_selectedGroupId != grupo.id) {
              _selectedGroupId = grupo.id;
              _selectedItems.clear();
            }
            if (isChecked) {
              _selectedItems.remove(key);
            } else {
              _selectedItems.removeWhere((item) {
                final parts = item.split('-');
                if (parts.length != 2) return false;
                int eqId = int.parse(parts[0]);
                int? hId = parts[1] == 'null' ? null : int.parse(parts[1]);
                return currentSchedules.any((s) => s['equipo_id'] == eqId && s['horario_id'] == hId);
              });
              _selectedItems.add(key);
            }
            _selectedBeneficiary = null;
            _selectedLugar = null;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isChecked ? AppTheme.primaryColor.withValues(alpha: 0.08) : (isDisabled ? AppTheme.neutral100 : Colors.white),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isChecked ? AppTheme.primaryColor : (isDisabled ? AppTheme.neutral200 : AppTheme.neutral300),
              width: isChecked ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isChecked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                size: 18,
                color: isChecked ? AppTheme.primaryColor : (isDisabled ? AppTheme.neutral300 : AppTheme.neutral400),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: isChecked ? AppTheme.primaryColor : (isDisabled ? AppTheme.neutral400 : AppTheme.neutral800),
                        fontWeight: isChecked ? FontWeight.w900 : FontWeight.w600,
                        fontSize: 12,
                        decoration: isHorarioFull ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 1,
                    ),
                    if (tieneCupo && cupoDisp != null)
                      Text(
                        isHorarioFull ? 'Agotado' : '$cupoDisp lugares',
                        style: TextStyle(
                          color: isHorarioFull ? AppTheme.dangerColor : (cupoDisp <= 3 ? Colors.orange : AppTheme.secondaryColor),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    children.add(
      LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - 8) / 2;
          return Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: chips.map((c) => SizedBox(width: itemWidth, child: c)).toList(),
          );
        },
      ),
    );

    children.add(const SizedBox(height: 8));
    return children;
  }
