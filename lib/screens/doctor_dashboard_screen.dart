import 'package:flutter/material.dart';
import '../widgets/info_card.dart';

// الشاشات الهدف
import 'add_prescription_screen.dart';
import 'appointment_screen.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const doctorName = 'د.أحمد'; // عدّل الاسم إن أردت

    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية (طبيب)'),
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
            Text('مرحباً $doctorName',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                children: [
                  // كارت «مرضاي» (Placeholder)
                  const InfoCard(
                    icon: Icons.people,
                    label: 'مرضاي',
                    onTap: null,
                  ),
                  // كارت «إضافة روشتة»
                  InfoCard(
                    icon: Icons.add_box_rounded,
                    label: 'إضافة روشتة',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddPrescriptionScreen(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
