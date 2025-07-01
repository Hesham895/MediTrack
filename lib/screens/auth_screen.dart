import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/primary_button.dart';
import '../models/user_model.dart';
import '../routes/route_manager.dart';
import '../services/api_service.dart';

final authTabProvider = StateProvider<int>((ref) => 0);
final authRoleProvider = StateProvider<UserRole?>((ref) => null);
final loadingProvider = StateProvider<bool>((ref) => false);

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name, email;
  UserRole? selectedRole;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = ref.watch(authTabProvider) == 0;
    final loading = ref.watch(loadingProvider);
    final userRole = ref.watch(authRoleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الدخول / التسجيل'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // --- هنا إضافة اللوجو أعلى الصفحة ---
                Image.asset(
                  'assets/meditrackLogo.png', // غيّر المسار حسب اسم وموقع اللوجو عندك
                  height: 180,
                  width: 230,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),

                ToggleButtons(
                  isSelected: [isLogin, !isLogin],
                  borderRadius: BorderRadius.circular(24),
                  selectedColor: Colors.white,
                  fillColor: Theme.of(context).colorScheme.primary,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('دخول'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('تسجيل'),
                    ),
                  ],
                  onPressed: (index) =>
                      ref.read(authTabProvider.notifier).state = index,
                ),
                const SizedBox(height: 24),
                if (!isLogin)
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'الاسم'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'الاسم مطلوب' : null,
                    onSaved: (v) => name = v,
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'البريد الإلكتروني'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || !v.contains('@')
                      ? 'أدخل بريدًا صحيحًا'
                      : null,
                  onSaved: (v) => email = v,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'كلمة المرور'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (v) =>
                      v == null || v.length < 6 ? '6 أحرف على الأقل' : null,
                ),
                if (!isLogin) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'تأكيد كلمة المرور'),
                    obscureText: true,
                    controller: _confirmPasswordController,
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'تأكيد كلمة المرور مطلوب';
                      if (v != _passwordController.text)
                        return 'كلمة المرور غير متطابقة';
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 20),
                DropdownButtonFormField<UserRole>(
                  value: userRole,
                  decoration: const InputDecoration(labelText: 'الدور'),
                  items: UserRole.values
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(_roleToStr(r)),
                        ),
                      )
                      .toList(),
                  onChanged: (r) =>
                      ref.read(authRoleProvider.notifier).state = r,
                  validator: (r) => r == null ? 'اختر الدور' : null,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: isLogin ? 'دخول' : 'تسجيل',
                  onPressed: loading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          _formKey.currentState!.save();

                          if (ref.read(authRoleProvider) == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('يرجى اختيار الدور')),
                            );
                            return;
                          }

                          ref.read(loadingProvider.notifier).state = true;
                          try {
                            late UserModel user;
                            final api = ref.read(apiServiceProvider);
                            if (isLogin) {
                              user = await api.login(
                                email!,
                                _passwordController.text,
                                ref.read(authRoleProvider)!,
                              );
                            } else {
                              user = await api.signup(
                                name!,
                                email!,
                                _passwordController.text,
                                ref.read(authRoleProvider)!,
                              );
                            }
                            switch (user.role) {
                              case UserRole.patient:
                                Navigator.pushReplacementNamed(
                                    context, RouteManager.patientDashboard);
                                break;
                              case UserRole.doctor:
                                Navigator.pushReplacementNamed(
                                    context, RouteManager.doctorDashboard);
                                break;
                              case UserRole.pharmacist:
                                Navigator.pushReplacementNamed(
                                    context, RouteManager.pharmacistDashboard);
                                break;
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('حدث خطأ: $e')),
                            );
                          } finally {
                            ref.read(loadingProvider.notifier).state = false;
                          }
                        },
                  loading: loading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _roleToStr(UserRole role) {
  switch (role) {
    case UserRole.patient:
      return 'مريض';
    case UserRole.doctor:
      return 'طبيب';
    case UserRole.pharmacist:
      return 'صيدلي';
  }
}
