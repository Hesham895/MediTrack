import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/appointment_model.dart';
import '../models/user_model.dart';

final appointmentTabProvider = StateProvider<int>((ref) => 0);

final appointmentsProvider =
    FutureProvider.family<List<AppointmentModel>, AppointmentStatus>(
        (ref, status) {
  final api = ref.read(apiServiceProvider);
  return api.appointments(status: status);
});

class AppointmentScreen extends ConsumerStatefulWidget {
  const AppointmentScreen({super.key});

  @override
  ConsumerState<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends ConsumerState<AppointmentScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // ✅ Listener مع فحص mounted لتجنّب setState بعد dispose
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging && mounted) {
      ref.read(appointmentTabProvider.notifier).state = _tabController.index;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const userRole = UserRole.patient;

    final currentTab = ref.watch(appointmentTabProvider);
    final status =
        currentTab == 0 ? AppointmentStatus.upcoming : AppointmentStatus.past;
    final appointmentsAsync = ref.watch(appointmentsProvider(status));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: const Text('المواعيد'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'القادمة'), Tab(text: 'السابقة')],
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: appointmentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('خطأ: $e')),
        data: (appointments) => appointments.isEmpty
            ? const Center(child: Text('لا يوجد مواعيد'))
            : ListView.builder(
                itemCount: appointments.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, idx) {
                  final appt = appointments[idx];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                          'مع: ${userRole == UserRole.patient ? 'الدكتور' : 'المريض'}'),
                      subtitle: Text('${appt.date} - ${appt.time}'),
                      trailing: Chip(
                        label: Text(_statusToAr(appt.status)),
                        backgroundColor: _statusColor(appt.status),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: userRole == UserRole.patient
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text('حجز موعد'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _BookAppointmentSheet(),
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24))),
                );
              },
            )
          : null,
    );
  }

  String _statusToAr(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.upcoming:
        return 'قادم';
      case AppointmentStatus.past:
        return 'سابق';
      case AppointmentStatus.cancelled:
        return 'ملغي';
    }
  }

  Color _statusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.upcoming:
        return Colors.teal.shade100;
      case AppointmentStatus.past:
        return Colors.grey.shade300;
      case AppointmentStatus.cancelled:
        return Colors.red.shade200;
    }
  }
}

class _BookAppointmentSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('حجز موعد جديد',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            items: const [
              DropdownMenuItem(value: 'd1', child: Text('دكتور أحمد'))
            ],
            onChanged: (v) {},
            decoration: const InputDecoration(labelText: 'اختيار الطبيب'),
          ),
          const SizedBox(height: 16),
          TextFormField(
              decoration: const InputDecoration(labelText: 'التاريخ'),
              onTap: () {}),
          const SizedBox(height: 16),
          TextFormField(
              decoration: const InputDecoration(labelText: 'الوقت'),
              onTap: () {}),
          const SizedBox(height: 16),
          TextFormField(decoration: const InputDecoration(labelText: 'السبب')),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('تم الحجز!')));
            },
            child: const Text('تأكيد الحجز'),
          ),
        ],
      ),
    );
  }
}
