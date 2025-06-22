from rest_framework import viewsets, generics
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.decorators import action
from django.shortcuts import get_object_or_404

from accounts.models import Patient
from accounts.serializers import PatientSerializer
from accounts.permissions import IsPatient
from medical.models import MedicalRecord, Prescription
from medical.serializers import MedicalRecordSerializer, PrescriptionSerializer

class PatientDashboardView(generics.RetrieveAPIView):
    permission_classes = [IsPatient]
    serializer_class = PatientSerializer
    
    def get_object(self):
        return get_object_or_404(Patient, user=self.request.user)
    
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        
        # Get latest medical records for the patient
        records = MedicalRecord.objects.filter(patient=instance).order_by('-created_at')[:5]
        records_serializer = MedicalRecordSerializer(records, many=True)
        
        # Get active prescriptions
        prescriptions = Prescription.objects.filter(
            medical_record__patient=instance,
            status='pending'
        ).order_by('-created_at')
        prescriptions_serializer = PrescriptionSerializer(prescriptions, many=True)
        
        response_data = serializer.data
        response_data['recent_records'] = records_serializer.data
        response_data['active_prescriptions'] = prescriptions_serializer.data
        
        return Response(response_data)

class PatientMedicalRecordViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for patients to view their own medical records (read-only)
    """
    serializer_class = MedicalRecordSerializer
    permission_classes = [IsPatient]
    
    def get_queryset(self):
        patient = get_object_or_404(Patient, user=self.request.user)
        return MedicalRecord.objects.filter(patient=patient).order_by('-created_at')

class PatientPrescriptionsViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for patients to view their own prescriptions (read-only)
    """
    serializer_class = PrescriptionSerializer
    permission_classes = [IsPatient]
    
    def get_queryset(self):
        patient = get_object_or_404(Patient, user=self.request.user)
        queryset = Prescription.objects.filter(medical_record__patient=patient)
        
        # Filter by status if provided
        status = self.request.query_params.get('status', None)
        if status:
            queryset = queryset.filter(status=status)
            
        return queryset.order_by('-created_at')
