import 'package:adipix/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Modelo para representar un día de la semana
class DayStatus {
  final String day;
  final bool completed;

  DayStatus({
    required this.day,
    required this.completed,
  });
}

/// Widget reutilizable que muestra la racha semanal
class WeeklyStreakWidget extends StatelessWidget {
  final List<DayStatus> days;
  final String? title;
  final TextStyle? titleStyle;
  final TextStyle? counterStyle;

  const WeeklyStreakWidget({
    super.key,
    required this.days,
    this.title = 'Esta semana',
    this.titleStyle,
    this.counterStyle,
  }) : assert(days.length == 7, 'Must provide exactly 7 days');

  @override
  Widget build(BuildContext context) {
    final completedDays = days.where((d) => d.completed).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title!,
              style: titleStyle ??
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              '$completedDays Días',
              style: counterStyle ??
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days
              .map((day) => _DayPill(
                    day: day.day,
                    isCompleted: day.completed,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

/// Widget interno para representar cada día individual
class _DayPill extends StatelessWidget {
  final String day;
  final bool isCompleted;

  const _DayPill({
    required this.day,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isCompleted
        ? AppTheme.primaryColor.withOpacity(0.9)
        : AppTheme.unselected;

    return Container(
      width: 40,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isCompleted ? Colors.white : AppTheme.primaryColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.white : AppTheme.greyBorder,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.check,
              size: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Clase helper para crear días de la semana fácilmente
class WeeklyStreakHelper {
  /// Crea una lista de días de la semana por defecto (Lun-Dom)
  static List<DayStatus> createWeek({
    bool mondayCompleted = false,
    bool tuesdayCompleted = false,
    bool wednesdayCompleted = false,
    bool thursdayCompleted = false,
    bool fridayCompleted = false,
    bool saturdayCompleted = false,
    bool sundayCompleted = false,
  }) {
    return [
      DayStatus(day: 'Lun', completed: mondayCompleted),
      DayStatus(day: 'Mar', completed: tuesdayCompleted),
      DayStatus(day: 'Mie', completed: wednesdayCompleted),
      DayStatus(day: 'Jue', completed: thursdayCompleted),
      DayStatus(day: 'Vie', completed: fridayCompleted),
      DayStatus(day: 'Sáb', completed: saturdayCompleted),
      DayStatus(day: 'Dom', completed: sundayCompleted),
    ];
  }

  /// Crea una semana desde una lista de booleanos
  static List<DayStatus> fromBoolList(List<bool> completedList) {
    assert(completedList.length == 7, 'Must provide exactly 7 boolean values');

    final days = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return List.generate(
      7,
      (index) => DayStatus(
        day: days[index],
        completed: completedList[index],
      ),
    );
  }

  /// Crea una semana con días completados consecutivos desde el inicio
  static List<DayStatus> withConsecutiveDays(int completedCount) {
    assert(completedCount >= 0 && completedCount <= 7,
        'completedCount must be between 0 and 7');

    final days = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return List.generate(
      7,
      (index) => DayStatus(
        day: days[index],
        completed: index < completedCount,
      ),
    );
  }
}
