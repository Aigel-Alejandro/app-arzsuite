                              Text(
                                '$ageText • Cupo: $spotsText',
                                style: TextStyle(
                                  color: isFull
                                      ? AppTheme.dangerColor
                                      : AppTheme.neutral600,
                                  fontSize: 13,
                                  fontWeight: isFull
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                              if (grupo.equipos
                                  .expand((e) => e.horarios)
                                  .isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    grupo.equipos
                                        .expand((e) => e.horarios)
                                        .map(
                                          (h) =>
                                              '${_shortDia(h.diaSemana)} ${h.horaInicio.substring(0, 5)}',
                                        )
                                        .toSet()
                                        .join(', '),
                                    style: TextStyle(
                                      color: isFull
                                          ? AppTheme.neutral400
                                          : AppTheme.primaryColor.withValues(
                                              alpha: 0.8,
                                            ),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
