import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../widgets/primary_button.dart';
import '../routes/route_manager.dart';
import '../models/user_model.dart';

final selectedRoleProvider = StateProvider<UserRole?>((ref) => null);

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRole = ref.watch(selectedRoleProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo (replace with your asset)
              Icon(Icons.local_hospital, color: AppColors.primary, size: 80),
              const SizedBox(height: 24),
              Text(
                'MediTrack',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 40),
              Text(
                'اختر نوع المستخدم',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _RoleChip(
                    icon: Icons.person,
                    label: 'مريض',
                    isSelected: selectedRole == UserRole.patient,
                    onTap: () => ref.read(selectedRoleProvider.notifier).state = UserRole.patient,
                  ),
                  _RoleChip(
                    icon: Icons.medical_services,
                    label: 'طبيب',
                    isSelected: selectedRole == UserRole.doctor,
                    onTap: () => ref.read(selectedRoleProvider.notifier).state = UserRole.doctor,
                  ),
                  _RoleChip(
                    icon: Icons.local_pharmacy,
                    label: 'صيدلي',
                    isSelected: selectedRole == UserRole.pharmacist,
                    onTap: () => ref.read(selectedRoleProvider.notifier).state = UserRole.pharmacist,
                  ),
                ],
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                text: 'استمرار',
                onPressed: selectedRole != null
                    ? () {
                        Navigator.pushReplacementNamed(
                          context,
                          RouteManager.auth,
                          arguments: selectedRole,
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primary : AppColors.accent,
      borderRadius: BorderRadius.circular(24),
      elevation: isSelected ? 4 : 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: 130,
          height: 60,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : AppColors.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}