import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/patient_model.dart';
import '../models/prescription_model.dart';
import '../models/appointment_model.dart';

// Stub for ApiService. Replace the code with your real API endpoints.
class ApiService {
  Future<UserModel> login(String email, String password, UserRole role) async {
    // TODO: Replace with real API logic.
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: '2323456789',
      name: 'هشام فتحي صلاح',
      email: email,
      role: role,
    );
  }

  Future<UserModel> signup(
      String name, String email, String password, UserRole role) async {
    // TODO: Replace with real API logic.
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: 'u2',
      name: name,
      email: email,
      role: role,
    );
  }

  Future<PatientModel> getPatientProfile(String patientId) async {
    // TODO: Replace with real API logic.
    await Future.delayed(const Duration(seconds: 1));
    return PatientModel(
      id: patientId,
      name: 'هشام فتحي صلاح',
      age: 30,
      gender: 'Male',
      bloodType: 'A+',
      chronicDiseases: ['Diabetes'],
      medications: ['Metformin'],
      labResults: [
        LabResult(
          title: 'CBC',
          date: '2025-06-25',
          resultUrl: 'https://example.com/lab1.pdf',
        ),
      ],
    );
  }

  Future<void> addPrescription(PrescriptionModel prescription) async {
    // TODO: Replace with real API logic.
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<List<PrescriptionModel>> listPrescriptions(
      {PrescriptionStatus? status}) async {
    // TODO: Replace with real API logic.
    await Future.delayed(const Duration(seconds: 1));
    return [
      PrescriptionModel(
        id: 'p1',
        patientId: 'u1',
        doctorId: 'd1',
        date: '2025-06-25',
        medications: [
          Medication(
            name: 'Paracetamol',
            dosage: '500mg',
            duration: '5 days',
            notes: 'After meals',
          ),
        ],
        status: PrescriptionStatus.pending,
      ),
    ];
  }

  Future<List<AppointmentModel>> appointments(
      {String? userId, UserRole? role, AppointmentStatus? status}) async {
    // TODO: Replace with real API logic.
    await Future.delayed(const Duration(seconds: 1));
    return [
      AppointmentModel(
        id: 'a1',
        patientId: 'u1',
        doctorId: 'd1',
        date: '2025-06-28',
        time: '10:00',
        status: AppointmentStatus.upcoming,
        reason: 'Consultation',
      ),
    ];
  }

  Future<void> updatePrescriptionStatus(
      String prescriptionId, PrescriptionStatus status) async {
    // TODO: Replace with real API logic.
    await Future.delayed(const Duration(seconds: 1));
  }
}

// Riverpod provider for ApiService
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
