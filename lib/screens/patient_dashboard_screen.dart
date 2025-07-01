import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import 'patient_profile_screen.dart';
import 'appointment_screen.dart';
import 'doctors_list_screen.dart'; // MUST import this file

class PatientDashboardScreen extends StatelessWidget {
  const PatientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userName =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'هشام';

    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية (مريض)'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('مرحباً بك، $userName',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                children: [
                  // كارت «ملفي الطبي»
                  InfoCard(
                    icon: Icons.person,
                    label: 'ملفي الطبي',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PatientProfileScreen(),
                        ),
                      );
                    },
                  ),
                  // كارت «المواعيد»
                  InfoCard(
                    icon: Icons.calendar_month,
                    label: 'المواعيد',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AppointmentScreen(),
                        ),
                      );
                    },
                  ),
                  // كارت «الأطباء»
                  InfoCard(
                    icon: Icons.medical_services,
                    label: 'الأطباء',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DoctorsListScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
