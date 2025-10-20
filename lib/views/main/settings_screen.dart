import 'package:adipix/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const SizedBox(height: 20),
        Text(
          'Ajustes',
          style: AppTheme.lightTheme.textTheme.headlineLarge,
        ),
        const SizedBox(height: 24),
        _buildProfileSection(),
        const SizedBox(height: 24),
        const Text(
          'Preferencias',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ..._buildSettingsOptions(context),
        const SizedBox(height: 24),
        const Text(
          'Cuenta',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ..._buildAccountOptions(context),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.greyBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Text(
                'N',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nick',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'nick@example.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.edit,
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSettingsOptions(BuildContext context) {
    final options = [
      {
        'icon': Icons.notifications,
        'title': 'Notificaciones',
        'subtitle': 'Gestiona tus alertas',
      },
      {
        'icon': Icons.language,
        'title': 'Idioma',
        'subtitle': 'Español',
      },
      {
        'icon': Icons.fitness_center,
        'title': 'Unidades',
        'subtitle': 'Kilogramos',
      },
      {
        'icon': Icons.dark_mode,
        'title': 'Tema',
        'subtitle': 'Modo claro',
      },
    ];

    return options.map((option) {
      return _buildSettingsTile(
        context,
        icon: option['icon'] as IconData,
        title: option['title'] as String,
        subtitle: option['subtitle'] as String,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${option['title']} presionado')),
          );
        },
      );
    }).toList();
  }

  List<Widget> _buildAccountOptions(BuildContext context) {
    final options = [
      {
        'icon': Icons.lock,
        'title': 'Cambiar contraseña',
        'color': AppTheme.primaryColor,
      },
      {
        'icon': Icons.help,
        'title': 'Ayuda y soporte',
        'color': AppTheme.primaryColor,
      },
      {
        'icon': Icons.info,
        'title': 'Acerca de',
        'color': AppTheme.primaryColor,
      },
      {
        'icon': Icons.logout,
        'title': 'Cerrar sesión',
        'color': Colors.red,
      },
    ];

    return options.map((option) {
      return _buildSettingsTile(
        context,
        icon: option['icon'] as IconData,
        title: option['title'] as String,
        iconColor: option['color'] as Color,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${option['title']} presionado')),
          );
        },
      );
    }).toList();
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.greyBorder),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? AppTheme.primaryColor,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
