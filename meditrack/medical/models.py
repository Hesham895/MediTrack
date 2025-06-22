from django.db import models
from accounts.models import Patient, Doctor

class MedicalRecord(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name='medical_records')
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, related_name='patient_records')
    diagnosis = models.TextField()
    symptoms = models.TextField()
    notes = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"Record for {self.patient.user.get_full_name()} by Dr. {self.doctor.user.get_full_name()}"

class Prescription(models.Model):
    PENDING = 'pending'
    FILLED = 'filled'
    CANCELLED = 'cancelled'
    
    STATUS_CHOICES = [
        (PENDING, 'Pending'),
        (FILLED, 'Filled'),
        (CANCELLED, 'Cancelled'),
    ]
    
    medical_record = models.ForeignKey(MedicalRecord, on_delete=models.CASCADE, related_name='prescriptions')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default=PENDING)
    filled_date = models.DateTimeField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"Prescription for {self.medical_record.patient.user.get_full_name()} ({self.status})"

class Medication(models.Model):
    prescription = models.ForeignKey(Prescription, on_delete=models.CASCADE, related_name='medications')
    name = models.CharField(max_length=255)
    dosage = models.CharField(max_length=100)
    frequency = models.CharField(max_length=100)
    duration = models.CharField(max_length=100)
    instructions = models.TextField(blank=True, null=True)
    
    def __str__(self):
        return f"{self.name} - {self.dosage}"
