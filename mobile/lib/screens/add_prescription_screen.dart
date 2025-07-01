import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/prescription_model.dart';

class AddPrescriptionScreen extends ConsumerStatefulWidget {
  const AddPrescriptionScreen({super.key});

  @override
  ConsumerState<AddPrescriptionScreen> createState() =>
      _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends ConsumerState<AddPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? patientId;
  String? medName;
  String? dosage;
  String? duration;
  String? diagnosis;
  String? imaging;
  String? notes;

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(_loadingProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('إضافة روشتة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // اختيار المريض
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'اختيار المريض'),
                items: const [
                  DropdownMenuItem(value: 'u1', child: Text('جون')),
                  DropdownMenuItem(value: 'u2', child: Text('ساره')),
                  DropdownMenuItem(value: 'u3', child: Text('مينا')),
                  DropdownMenuItem(value: 'u4', child: Text('هشام')),
                  DropdownMenuItem(value: 'u5', child: Text('عمر')),
                  DropdownMenuItem(value: 'u6', child: Text('عبدالله')),
                  DropdownMenuItem(value: 'u7', child: Text('يوسف')),
                  DropdownMenuItem(value: 'u8', child: Text('ليلي')),
                ],
                onChanged: (v) => patientId = v,
                validator: (v) => v == null || v.isEmpty ? 'اختر المريض' : null,
              ),
              const SizedBox(height: 16),

              // التاريخ
              TextFormField(
                decoration: const InputDecoration(labelText: 'التاريخ'),
                onSaved: (v) =>
                    duration = v, // نستخدم duration كحقل التاريخ مؤقتًا
                validator: (v) =>
                    v == null || v.isEmpty ? 'ادخل التاريخ' : null,
              ),
              const SizedBox(height: 16),

              // التشخيص (عدة أسطر)
              TextFormField(
                decoration: const InputDecoration(labelText: 'التشخيص'),
                onSaved: (v) => diagnosis = v,
                validator: (v) =>
                    v == null || v.isEmpty ? 'اكتب التشخيص' : null,
                minLines: 1,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),

              // الدواء والجرعة (عدة أسطر)
              TextFormField(
                decoration: const InputDecoration(labelText: 'الدواء والجرعة'),
                onSaved: (v) => medName =
                    v, // نفترض أن المستخدم يكتب اسم الدواء والجرعة سويًا
                validator: (v) =>
                    v == null || v.isEmpty ? 'ادخل الدواء والجرعة' : null,
                minLines: 1,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),

              // المدة
              TextFormField(
                decoration: const InputDecoration(labelText: 'المدة'),
                onSaved: (v) => duration = v,
                validator: (v) => v == null || v.isEmpty ? 'ادخل المدة' : null,
              ),
              const SizedBox(height: 16),

              // الأشعة والتحاليل (عدة أسطر)
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'الأشعة و التحاليل'),
                onSaved: (v) => imaging = v,
                validator: (v) =>
                    v == null || v.isEmpty ? 'ادخل الأشعة والتحاليل' : null,
                minLines: 1,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),

              // ملاحظات (عدة أسطر)
              TextFormField(
                decoration: const InputDecoration(labelText: 'ملاحظات'),
                onSaved: (v) => notes = v,
                minLines: 1,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 32),

              // زر الإضافة
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        _formKey.currentState!.save();
                        ref.read(_loadingProvider.notifier).state = true;
                        try {
                          final api = ref.read(apiServiceProvider);
                          await api.addPrescription(
                            PrescriptionModel(
                              id: 'new',
                              patientId: patientId!,
                              doctorId: 'd1',
                              date: DateTime.now().toString(),
                              medications: [
                                Medication(
                                  name: medName ?? '',
                                  dosage: dosage ?? '',
                                  duration: duration ?? '',
                                  notes: notes ?? '',
                                ),
                              ],
                              status: PrescriptionStatus.pending,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تمت الإضافة!')),
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('خطأ: $e')),
                          );
                        } finally {
                          ref.read(_loadingProvider.notifier).state = false;
                        }
                      },
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('إضافة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _loadingProvider = StateProvider<bool>((ref) => false);
