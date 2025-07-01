import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes/route_manager.dart';

// شاشات البداية
import 'screens/splash_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/auth_screen.dart';

// Dashboards
import 'screens/patient_dashboard_screen.dart';
import 'screens/doctor_dashboard_screen.dart';
import 'screens/pharmacist_dashboard_screen.dart';

// Features (يمكنك فتحها بالـ push أو pushNamed حسب الحاجة)
import 'screens/patient_profile_screen.dart';
import 'screens/appointment_screen.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'meditrack',
      debugShowCheckedModeBanner: false,

      // Splash هي أول شاشة
      initialRoute: RouteManager.splash,

      routes: {
        // صفحات عامة
        RouteManager.splash: (_) => const SplashScreen(),
        RouteManager.roleSelection: (_) => const RoleSelectionScreen(),

        // شاشات الدخول/التسجيل
        RouteManager.auth: (_) => const AuthScreen(),

        // Dashboards
        RouteManager.patientDashboard: (_) => const PatientDashboardScreen(),
        RouteManager.doctorDashboard: (_) => const DoctorDashboardScreen(),
        RouteManager.pharmacistDashboard: (_) =>
            const PharmacistDashboardScreen(),

        // صفحات إضافية تُستدعى بالـ pushNamed (إن أردت)
        RouteManager.patientProfile: (_) => const PatientProfileScreen(),
        RouteManager.appointment: (_) => const AppointmentScreen(),
      },

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        cardTheme: CardThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 3,
          shadowColor: Colors.grey.shade200,
        ),
      ),
    );
  }
}
