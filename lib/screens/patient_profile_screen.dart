import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/profile_header.dart';
import '../services/api_service.dart';
import '../models/patient_model.dart';
import '../models/user_model.dart';

final patientProfileProvider =
    FutureProvider.family<PatientModel, String>((ref, patientId) {
  final api = ref.read(apiServiceProvider);
  return api.getPatientProfile(patientId);
});

class PatientProfileScreen extends ConsumerWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const patientId = 'u1'; // placeholder

    final profileAsync = ref.watch(patientProfileProvider(patientId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // ◀︎ زر رجوع واضح
        ),
        title: const Text('ملف المريض'),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('خطأ: $e')),
        data: (patient) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ProfileHeader(
                name: patient.name,
                id: patient.id,
                avatarUrl: null,
              ),
              const SizedBox(height: 32),
              _buildAccordion(context, patient),
            ],
          ),
        ),
      ),
      floatingActionButton: _shouldShowFab(ref)
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text('إضافة نتيجة'),
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('قريبًا...'))),
            )
          : null,
    );
  }

  bool _shouldShowFab(WidgetRef ref) {
    const currentRole = UserRole.doctor; // مثال
    return currentRole == UserRole.doctor;
  }

  Widget _buildAccordion(BuildContext context, PatientModel patient) {
    return Column(
      children: [
        ExpansionTile(
          title: const Text('المعلومات الأساسية'),
          children: [
            ListTile(
              title: Text(
                  'العمر: ${patient.age}, الجنس: ${patient.gender}, فصيلة الدم: ${patient.bloodType}'),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('الأمراض المزمنة'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                children: patient.chronicDiseases
                    .map((d) => Chip(label: Text(d)))
                    .toList(),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('الأدوية الحالية'),
          children: patient.medications
              .map((med) => ListTile(title: Text(med)))
              .toList(),
        ),
        ExpansionTile(
          title: const Text('نتائج التحاليل والفحوصات'),
          children: patient.labResults.map((lab) {
            return ListTile(
              title: Text(lab.title),
              subtitle: Text(lab.date),
              trailing: const Icon(Icons.picture_as_pdf),
              onTap: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('فتح الرابط...'))),
            );
          }).toList(),
        ),
      ],
    );
  }
}
