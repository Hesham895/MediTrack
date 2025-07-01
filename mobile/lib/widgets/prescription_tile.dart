import 'package:flutter/material.dart';
import '../models/prescription_model.dart';

class PrescriptionTile extends StatelessWidget {
  final PrescriptionModel prescription;
  final VoidCallback? onDispense;

  const PrescriptionTile({
    super.key,
    required this.prescription,
    this.onDispense,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.receipt_long_rounded),
        title: Text('مريض: ${prescription.patientId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('دكتور: ${prescription.doctorId}'),
            ...prescription.medications
                .map((m) => Text('${m.name} (${m.dosage}) - ${m.duration}'))
                .toList(),
            Text('تاريخ: ${prescription.date}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chip(
              label: Text(_statusToAr(prescription.status)),
              backgroundColor: prescription.status == PrescriptionStatus.dispensed
                  ? Colors.green.shade100
                  : Colors.orange.shade100,
            ),
            if (onDispense != null)
              TextButton(
                onPressed: onDispense,
                child: const Text('تم الصرف'),
              ),
          ],
        ),
      ),
    );
  }

  String _statusToAr(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.pending:
        return 'قيد الانتظار';
      case PrescriptionStatus.dispensed:
        return 'تم الصرف';
    }
  }
}