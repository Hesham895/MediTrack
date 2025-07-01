import 'package:equatable/equatable.dart';

enum AppointmentStatus { upcoming, past, cancelled }

class AppointmentModel extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final String date;
  final String time;
  final AppointmentStatus status;
  final String reason;

  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.status,
    required this.reason,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
        id: json['id'],
        patientId: json['patientId'],
        doctorId: json['doctorId'],
        date: json['date'],
        time: json['time'],
        status: AppointmentStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => AppointmentStatus.upcoming,
        ),
        reason: json['reason'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'doctorId': doctorId,
        'date': date,
        'time': time,
        'status': status.name,
        'reason': reason,
      };

  @override
  List<Object?> get props => [id, patientId, doctorId, date, time, status, reason];
}