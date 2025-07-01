import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart'; // For localization toggle if needed

final notificationSwitchProvider = StateProvider<bool>((ref) => true);
final languageProvider = StateProvider<Locale>((ref) => const Locale('ar'));

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationOn = ref.watch(notificationSwitchProvider);
    final locale = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text('الملف الشخصي', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(labelText: 'اسم المستخدم'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('الإشعارات'),
            value: notificationOn,
            onChanged: (v) => ref.read(notificationSwitchProvider.notifier).state = v,
          ),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('اللغة'),
            trailing: DropdownButton<Locale>(
              value: locale,
              items: const [
                DropdownMenuItem(child: Text('العربية'), value: Locale('ar')),
                DropdownMenuItem(child: Text('English'), value: Locale('en')),
              ],
              onChanged: (v) {
                if (v != null) ref.read(languageProvider.notifier).state = v;
              },
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('تسجيل الخروج'),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () {
              // Clear token, then navigate to RoleSelectionScreen
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}