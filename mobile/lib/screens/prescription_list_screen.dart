import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/prescription_model.dart';
import '../widgets/prescription_tile.dart';

final prescriptionStatusProvider = StateProvider<PrescriptionStatus>((ref) => PrescriptionStatus.pending);

final prescriptionsProvider = FutureProvider<List<PrescriptionModel>>((ref) {
  final api = ref.read(apiServiceProvider);
  final status = ref.watch(prescriptionStatusProvider);
  return api.listPrescriptions(status: status);
});

class PrescriptionListScreen extends ConsumerWidget {
  const PrescriptionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(prescriptionStatusProvider);
    final prescriptionsAsync = ref.watch(prescriptionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('قائمة الروشتات')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Wrap(
              spacing: 12,
              children: [
                FilterChip(
                  label: const Text('قيد الانتظار'),
                  selected: status == PrescriptionStatus.pending,
                  onSelected: (selected) => ref.read(prescriptionStatusProvider.notifier).state = PrescriptionStatus.pending,
                ),
                FilterChip(
                  label: const Text('تم الصرف'),
                  selected: status == PrescriptionStatus.dispensed,
                  onSelected: (selected) => ref.read(prescriptionStatusProvider.notifier).state = PrescriptionStatus.dispensed,
                ),
              ],
            ),
          ),
          Expanded(
            child: prescriptionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('خطأ: $e')),
              data: (prescriptions) => prescriptions.isEmpty
                  ? const Center(child: Text('لا توجد روشتات'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: prescriptions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, idx) {
                        final presc = prescriptions[idx];
                        return PrescriptionTile(
                          prescription: presc,
                          onDispense: presc.status == PrescriptionStatus.pending
                              ? () async {
                                  final api = ref.read(apiServiceProvider);
                                  await api.updatePrescriptionStatus(
                                    presc.id,
                                    PrescriptionStatus.dispensed,
                                  );
                                  ref.invalidate(prescriptionsProvider);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم صرف الروشتة!')));
                                }
                              : null,
                        );
                      }),
            ),
          ),
        ],
      ),
    );
  }
}