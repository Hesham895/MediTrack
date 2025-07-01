from rest_framework import viewsets, permissions, status
from rest_framework.response import Response
from rest_framework.decorators import action, api_view, permission_classes
from django.shortcuts import get_object_or_404
import logging

from .models import MedicalRecord, Prescription, Medication
from .serializers import MedicalRecordSerializer, PrescriptionSerializer, MedicationSerializer
from .permissions import IsPatientOwner, IsDoctorOwnerOrPatientReadOnly
from accounts.permissions import IsDoctor, IsPharmacist, IsPatient
from accounts.models import Patient, Doctor

logger = logging.getLogger(__name__)

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
    
    def create(self, request, *args, **kwargs):
        try:
            # Log the request data for debugging
            logger.info(f"Creating prescription with data: {request.data}")
            
            # Add additional validation if needed
            medical_record_id = request.data.get('medical_record')
            if not medical_record_id:
                return Response(
                    {"error": "medical_record field is required"},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Try to get the medical record
            try:
                medical_record = MedicalRecord.objects.get(id=medical_record_id)
            except MedicalRecord.DoesNotExist:
                return Response(
                    {"error": f"Medical record with ID {medical_record_id} does not exist"},
                    status=status.HTTP_404_NOT_FOUND
                )
            
            # Check if the user is the doctor for this record
            doctor = get_object_or_404(Doctor, user=request.user)
            if medical_record.doctor != doctor:
                return Response(
                    {"error": "You don't have permission for this medical record"},
                    status=status.HTTP_403_FORBIDDEN
                )
            
            # Check if medications are provided
            medications = request.data.get('medications', [])
            if not medications:
                return Response(
                    {"error": "At least one medication is required"},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Proceed with normal creation
            return super().create(request, *args, **kwargs)
        except Exception as e:
            # Log the error
            logger.error(f"Error creating prescription: {str(e)}")
            # Catch any unexpected errors and return a helpful message
            return Response(
                {"error": f"An unexpected error occurred: {str(e)}"},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
    
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

@api_view(['POST'])
@permission_classes([IsDoctor])
def create_prescription(request):
    """
    A simplified endpoint for creating prescriptions with better error handling.
    """
    try:
        medical_record_id = request.data.get('medical_record')
        medications = request.data.get('medications', [])
        
        # Validate required fields
        if not medical_record_id:
            return Response(
                {"error": "medical_record field is required"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if not medications:
            return Response(
                {"error": "At least one medication is required"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Try to get the medical record
        try:
            medical_record = MedicalRecord.objects.get(id=medical_record_id)
        except MedicalRecord.DoesNotExist:
            return Response(
                {"error": f"Medical record with ID {medical_record_id} does not exist"},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Check if the user is the doctor for this record
        doctor = get_object_or_404(Doctor, user=request.user)
        if medical_record.doctor != doctor:
            return Response(
                {"error": "You don't have permission for this medical record"},
                status=status.HTTP_403_FORBIDDEN
            )
        
        # Create the prescription
        prescription = Prescription.objects.create(medical_record=medical_record)
        
        # Create medications
        for med_data in medications:
            Medication.objects.create(
                prescription=prescription,
                name=med_data.get('name', ''),
                dosage=med_data.get('dosage', ''),
                frequency=med_data.get('frequency', ''),
                duration=med_data.get('duration', ''),
                instructions=med_data.get('instructions', '')
            )
        
        # Return the created prescription
        serializer = PrescriptionSerializer(prescription)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    
    except Exception as e:
        # Log the error
        logger.error(f"Error in simplified prescription creation: {str(e)}")
        return Response(
            {"error": f"An unexpected error occurred: {str(e)}"},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )
