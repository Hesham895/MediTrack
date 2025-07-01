import 'package:equatable/equatable.dart';

enum PrescriptionStatus { pending, dispensed }

class PrescriptionModel extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final String date;
  final List<Medication> medications;
  final PrescriptionStatus status;

  const PrescriptionModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.medications,
    required this.status,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) => PrescriptionModel(
        id: json['id'],
        patientId: json['patientId'],
        doctorId: json['doctorId'],
        date: json['date'],
        medications: (json['medications'] as List<dynamic>? ?? [])
            .map((e) => Medication.fromJson(e))
            .toList(),
        status: PrescriptionStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => PrescriptionStatus.pending,
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'doctorId': doctorId,
        'date': date,
        'medications': medications.map((e) => e.toJson()).toList(),
        'status': status.name,
      };

  @override
  List<Object?> get props => [id, patientId, doctorId, date, medications, status];
}

class Medication extends Equatable {
  final String name;
  final String dosage;
  final String duration;
  final String notes;

  const Medication({
    required this.name,
    required this.dosage,
    required this.duration,
    required this.notes,
  });

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
        name: json['name'],
        dosage: json['dosage'],
        duration: json['duration'],
        notes: json['notes'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'dosage': dosage,
        'duration': duration,
        'notes': notes,
      };

  @override
  List<Object?> get props => [name, dosage, duration, notes];
}