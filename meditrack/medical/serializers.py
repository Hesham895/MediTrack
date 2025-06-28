from rest_framework import serializers
from .models import MedicalRecord, Prescription, Medication
from accounts.models import Doctor

class MedicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medication
        fields = ('id', 'name', 'dosage', 'frequency', 'duration', 'instructions')

class PrescriptionSerializer(serializers.ModelSerializer):
    medications = MedicationSerializer(many=True)
    
    class Meta:
        model = Prescription
        fields = ('id', 'status', 'filled_date', 'created_at', 'medical_record', 'medications')
        read_only_fields = ('created_at',)
    
    def validate_medical_record(self, value):
        """
        Check that the medical record exists and user has permission.
        """
        try:
            record = MedicalRecord.objects.get(id=value.id)
            # Check if the user is the doctor for this record or has appropriate permissions
            user = self.context.get('request', None).user if self.context.get('request') else None
            if user and hasattr(user, 'is_doctor') and user.is_doctor:
                doctor = Doctor.objects.get(user=user)
                if record.doctor != doctor:
                    raise serializers.ValidationError("You don't have permission for this medical record.")
            return value
        except MedicalRecord.DoesNotExist:
            raise serializers.ValidationError(f"Medical record with ID {value.id} does not exist.")
        except Exception as e:
            raise serializers.ValidationError(f"Validation error: {str(e)}")
    
    def create(self, validated_data):
        medications_data = validated_data.pop('medications')
        prescription = Prescription.objects.create(**validated_data)
        
        for medication_data in medications_data:
            Medication.objects.create(prescription=prescription, **medication_data)
        
        return prescription

class MedicalRecordSerializer(serializers.ModelSerializer):
    prescriptions = PrescriptionSerializer(many=True, read_only=True)
    doctor_name = serializers.SerializerMethodField()  

    class Meta:
        model = MedicalRecord
        fields = (
            'id',
            'patient',
            'doctor',
            'doctor_name',  
            'diagnosis',
            'symptoms',
            'notes',
            'created_at',
            'prescriptions'
        )
        read_only_fields = ('created_at', 'doctor')

    def get_doctor_name(self, obj):
        try:
            return f"{obj.doctor.user.first_name} {obj.doctor.user.last_name}"
        except AttributeError:
            return None