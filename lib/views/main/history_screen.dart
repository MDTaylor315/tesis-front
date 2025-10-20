import 'package:adipix/theme/app_theme.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const SizedBox(height: 20),
        Text(
          'Historial',
          style: AppTheme.lightTheme.textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Revisa tu progreso histórico',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        ..._buildHistoryItems(),
      ],
    );
  }

  List<Widget> _buildHistoryItems() {
    final history = [
      {
        'date': '18 de Octubre, 2025',
        'weight': '120.0 kg',
        'fatPercentage': '40.0%',
        'completed': true,
      },
      {
        'date': '17 de Octubre, 2025',
        'weight': '120.2 kg',
        'fatPercentage': '40.1%',
        'completed': true,
      },
      {
        'date': '16 de Octubre, 2025',
        'weight': '120.5 kg',
        'fatPercentage': '40.3%',
        'completed': true,
      },
      {
        'date': '15 de Octubre, 2025',
        'weight': '121.0 kg',
        'fatPercentage': '40.5%',
        'completed': false,
      },
      {
        'date': '14 de Octubre, 2025',
        'weight': '121.2 kg',
        'fatPercentage': '40.6%',
        'completed': true,
      },
    ];

    return history.map((item) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.greyBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: item['completed'] as bool
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : AppTheme.unselected,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item['completed'] as bool ? Icons.check_circle : Icons.cancel,
                color: item['completed'] as bool
                    ? AppTheme.primaryColor
                    : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['date'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Peso: ${item['weight']} • Grasa: ${item['fatPercentage']}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      );
    }).toList();
  }
}
