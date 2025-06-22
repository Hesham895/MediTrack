from rest_framework import serializers
from .models import PharmacyLog
from medical.models import Prescription
from medical.serializers import PrescriptionSerializer
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