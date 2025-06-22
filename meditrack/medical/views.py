from rest_framework import viewsets, permissions, status
from rest_framework.response import Response
from rest_framework.decorators import action
from django.shortcuts import get_object_or_404

from .models import MedicalRecord, Prescription, Medication
from .serializers import MedicalRecordSerializer, PrescriptionSerializer, MedicationSerializer
from .permissions import IsPatientOwner, IsDoctorOwnerOrPatientReadOnly
from accounts.permissions import IsDoctor, IsPharmacist, IsPatient
from accounts.models import Patient, Doctor

class MedicalRecordViewSet(viewsets.ModelViewSet):
    serializer_class = MedicalRecordSerializer
    
    def get_permissions(self):
        """
        Instantiates and returns the list of permissions that this view requires.
        """
        if self.action == 'create':
            permission_classes = [IsDoctor]
        elif self.action in ['update', 'partial_update', 'destroy']:
            permission_classes = [IsDoctor, IsDoctorOwnerOrPatientReadOnly]
        else:  # list, retrieve
            permission_classes = [permissions.IsAuthenticated, IsDoctorOwnerOrPatientReadOnly]
        return [permission() for permission in permission_classes]
    
    def get_queryset(self):
        user = self.request.user
        
        if user.is_doctor:
            # Doctors can see records they created
            doctor = get_object_or_404(Doctor, user=user)
            return MedicalRecord.objects.filter(doctor=doctor)
        elif user.is_patient:
            # Patients can see their own records
            patient = get_object_or_404(Patient, user=user)
            return MedicalRecord.objects.filter(patient=patient)
        elif user.is_pharmacist:
            # Pharmacists can only see records with active prescriptions
            return MedicalRecord.objects.filter(prescriptions__status='pending')
        
        # Admins can see all
        return MedicalRecord.objects.all()
    
    def perform_create(self, serializer):
        doctor = get_object_or_404(Doctor, user=self.request.user)
        serializer.save(doctor=doctor)

class PrescriptionViewSet(viewsets.ModelViewSet):
    serializer_class = PrescriptionSerializer
    
    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update']:
            permission_classes = [IsDoctor]
        elif self.action == 'fill_prescription':
            permission_classes = [IsPharmacist]
        elif self.action == 'destroy':
            permission_classes = [IsDoctor]
        else:  # list, retrieve
            permission_classes = [permissions.IsAuthenticated]
        return [permission() for permission in permission_classes]
    
    def get_queryset(self):
        user = self.request.user
        
        if user.is_doctor:
            # Doctors can see prescriptions they created
            doctor = get_object_or_404(Doctor, user=user)
            return Prescription.objects.filter(medical_record__doctor=doctor)
        elif user.is_patient:
            # Patients can see their own prescriptions
            patient = get_object_or_404(Patient, user=user)
            return Prescription.objects.filter(medical_record__patient=patient)
        elif user.is_pharmacist:
            # Pharmacists can see pending prescriptions
            return Prescription.objects.filter(status='pending')
        
        # Admins can see all
        return Prescription.objects.all()
    
    @action(detail=True, methods=['post'])
    def fill_prescription(self, request, pk=None):
        prescription = self.get_object()
        if prescription.status != 'pending':
            return Response(
                {"error": "This prescription has already been processed."},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        prescription.status = 'filled'
        prescription.save()
        
        serializer = self.get_serializer(prescription)
        return Response(serializer.data)
