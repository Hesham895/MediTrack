from rest_framework import serializers
from .models import PharmacyLog
from medical.models import Prescription, Medication
from medical.serializers import MedicationSerializer
from accounts.models import Patient
from datetime import datetime

class PharmacyLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = PharmacyLog
        fields = ('id', 'pharmacist', 'prescription', 'notes', 'created_at')
        read_only_fields = ('created_at',)

class PrescriptionFillSerializer(serializers.ModelSerializer):
    notes = serializers.CharField(required=False, allow_blank=True)
    
    class Meta:
        model = Prescription
        fields = ('id', 'notes')
        
    def update(self, instance, validated_data):
        notes = validated_data.pop('notes', '')
        
        # Update prescription status
        instance.status = 'filled'
        instance.filled_date = datetime.now()
        instance.save()
        
        # Create pharmacy log
        PharmacyLog.objects.create(
            pharmacist=self.context['request'].user.pharmacist_profile,
            prescription=instance,
            notes=notes
        )
        
        return instance

# New serializer for pharmacist dashboard with limited patient info
class PatientLimitedInfoSerializer(serializers.ModelSerializer):
    full_name = serializers.SerializerMethodField()
    
    class Meta:
        model = Patient
        fields = ('id', 'full_name')
    
    def get_full_name(self, obj):
        return obj.user.get_full_name()

# New serializer for pharmacist dashboard with prescriptions
class PharmacistPrescriptionSerializer(serializers.ModelSerializer):
    patient = serializers.SerializerMethodField()
    medications = MedicationSerializer(many=True, read_only=True)
    prescription_id = serializers.CharField(source='id', read_only=True)
    created_date = serializers.DateTimeField(source='created_at', format='%Y-%m-%d', read_only=True)
    
    class Meta:
        model = Prescription
        fields = ('prescription_id', 'status', 'filled_date', 'created_date', 'patient', 'medications')
        read_only_fields = ('prescription_id', 'created_date', 'filled_date')
    
    def get_patient(self, obj):
        patient = obj.medical_record.patient
        serializer = PatientLimitedInfoSerializer(patient)
        return serializer.data