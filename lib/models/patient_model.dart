import 'package:equatable/equatable.dart';

class PatientModel extends Equatable {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String bloodType;
  final List<String> chronicDiseases;
  final List<String> medications;
  final List<LabResult> labResults;

  const PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodType,
    required this.chronicDiseases,
    required this.medications,
    required this.labResults,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        gender: json['gender'],
        bloodType: json['bloodType'],
        chronicDiseases: List<String>.from(json['chronicDiseases'] ?? []),
        medications: List<String>.from(json['medications'] ?? []),
        labResults: (json['labResults'] as List<dynamic>? ?? [])
            .map((e) => LabResult.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'bloodType': bloodType,
        'chronicDiseases': chronicDiseases,
        'medications': medications,
        'labResults': labResults.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props =>
      [id, name, age, gender, bloodType, chronicDiseases, medications, labResults];
}

class LabResult extends Equatable {
  final String title;
  final String date;
  final String resultUrl;

  const LabResult({
    required this.title,
    required this.date,
    required this.resultUrl,
  });

  factory LabResult.fromJson(Map<String, dynamic> json) => LabResult(
        title: json['title'],
        date: json['date'],
        resultUrl: json['resultUrl'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date,
        'resultUrl': resultUrl,
      };

  @override
  List<Object?> get props => [title, date, resultUrl];
}