import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../routes/route_manager.dart';

class PharmacistDashboardScreen extends StatelessWidget {
  const PharmacistDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _DashboardCardData(
        title: 'الروشتات',
        icon: Icons.medical_information,
        route: RouteManager.prescriptionList,
      ),
      _DashboardCardData(
        title: 'معلومات المريض',
        icon: Icons.info_outline,
        route: RouteManager.patientProfile, // read-only
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية (صيدلي)'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                Navigator.pushNamed(context, RouteManager.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مرحباً بك، د.محمود',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                children: cards
                    .map(
                      (card) => InfoCard(
                        icon: card.icon,
                        label: card.title,
                        onTap: card.route == null
                            ? null
                            : () {
                                Navigator.pushNamed(context, card.route!);
                              },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCardData {
  final String title;
  final IconData icon;
  final String? route;

  _DashboardCardData({
    required this.title,
    required this.icon,
    required this.route,
  });
}
