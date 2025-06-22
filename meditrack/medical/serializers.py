from rest_framework import serializers
from .models import MedicalRecord, Prescription, Medication

class MedicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medication
        fields = ('id', 'name', 'dosage', 'frequency', 'duration', 'instructions')

class PrescriptionSerializer(serializers.ModelSerializer):
    medications = MedicationSerializer(many=True)
    
    class Meta:
        model = Prescription
        fields = ('id', 'status', 'filled_date', 'created_at', 'medications')
        read_only_fields = ('created_at',)
    
    def create(self, validated_data):
        medications_data = validated_data.pop('medications')
        prescription = Prescription.objects.create(**validated_data)
        
        for medication_data in medications_data:
            Medication.objects.create(prescription=prescription, **medication_data)
        
        return prescription

class MedicalRecordSerializer(serializers.ModelSerializer):
    doctor_name = serializers.SerializerMethodField()
    patient_name = serializers.SerializerMethodField()
    prescriptions = PrescriptionSerializer(many=True, read_only=True)
    
    class Meta:
        model = MedicalRecord
        fields = ('id', 'doctor', 'doctor_name', 'patient', 'patient_name', 
                  'diagnosis', 'symptoms', 'notes', 'created_at', 'prescriptions')
        read_only_fields = ('created_at',)
    
    def get_doctor_name(self, obj):
        return f"Dr. {obj.doctor.user.get_full_name()}"
    
    def get_patient_name(self, obj):
        return obj.patient.user.get_full_name()