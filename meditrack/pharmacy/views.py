from rest_framework import viewsets, permissions, status, filters
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from django.db.models import Q

from .models import PharmacyLog
from .serializers import (
    PharmacyLogSerializer, 
    PrescriptionFillSerializer,
    PharmacistPrescriptionSerializer
)
from accounts.permissions import IsPharmacist
from medical.models import Prescription
from accounts.models import Pharmacist, Patient

class PharmacyViewSet(viewsets.GenericViewSet):
    permission_classes = [IsPharmacist]
    
    def get_queryset(self):
        return Prescription.objects.filter(status='pending')
    
    @action(detail=False, methods=['get'])
    def pending_prescriptions(self, request):
        prescriptions = self.get_queryset()
        page = self.paginate_queryset(prescriptions)
        if page is not None:
            from medical.serializers import PrescriptionSerializer
            serializer = PrescriptionSerializer(page, many=True)
            return self.get_paginated_response(serializer.data)
        
        serializer = PrescriptionSerializer(prescriptions, many=True)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def fill_prescription(self, request, pk=None):
        prescription = get_object_or_404(Prescription, pk=pk)
        pharmacist = get_object_or_404(Pharmacist, user=request.user)
        
        if prescription.status != 'pending':
            return Response(
                {"error": "This prescription has already been processed."},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        serializer = PrescriptionFillSerializer(
            prescription, 
            data=request.data, 
            context={'request': request}
        )
        
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class PharmacyLogViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = PharmacyLogSerializer
    permission_classes = [IsPharmacist]
    
    def get_queryset(self):
        pharmacist = get_object_or_404(Pharmacist, user=self.request.user)
        return PharmacyLog.objects.filter(pharmacist=pharmacist)

# New pharmacist dashboard view
class PharmacistDashboardView(APIView):
    """
    API endpoint that provides an overview of pending prescriptions and
    recently filled prescriptions for the pharmacist dashboard.
    """
    permission_classes = [IsPharmacist]
    
    def get(self, request):
        # Get pending prescriptions
        pending_prescriptions = Prescription.objects.filter(status='pending')
        
        # Get recently filled prescriptions by this pharmacist
        pharmacist = get_object_or_404(Pharmacist, user=request.user)
        filled_logs = PharmacyLog.objects.filter(pharmacist=pharmacist).order_by('-created_at')[:5]
        filled_prescriptions = [log.prescription for log in filled_logs]
        
        # Serialize the prescriptions with limited patient info
        pending_serializer = PharmacistPrescriptionSerializer(pending_prescriptions, many=True)
        filled_serializer = PharmacistPrescriptionSerializer(filled_prescriptions, many=True)
        
        return Response({
            'pending_prescriptions': pending_serializer.data,
            'recent_filled_prescriptions': filled_serializer.data,
        })

# New view for listing prescriptions with limited patient info
class PharmacistPrescriptionViewSet(viewsets.ReadOnlyModelViewSet):
    """
    API endpoint that allows pharmacists to view prescriptions with limited
    patient information and provides search functionality.
    """
    serializer_class = PharmacistPrescriptionSerializer
    permission_classes = [IsPharmacist]
    filter_backends = [filters.SearchFilter]
    search_fields = ['medical_record__patient__user__first_name', 
                     'medical_record__patient__user__last_name', 
                     'medical_record__patient__id']
    
    def get_queryset(self):
        status_filter = self.request.query_params.get('status', None)
        queryset = Prescription.objects.all().select_related('medical_record__patient__user')
        
        if status_filter == 'pending':
            queryset = queryset.filter(status='pending')
        elif status_filter == 'filled':
            queryset = queryset.filter(status='filled')
        
        # Add patient search parameter
        patient_search = self.request.query_params.get('patient', None)
        if patient_search:
            queryset = queryset.filter(
                Q(medical_record__patient__user__first_name__icontains=patient_search) | 
                Q(medical_record__patient__user__last_name__icontains=patient_search) |
                Q(medical_record__patient__id__iexact=patient_search)
            )
            
        return queryset
    
    @action(detail=False, methods=['get'])
    def search_patient(self, request):
        """
        Search for patients by name or ID and return their pending prescriptions.
        Usage: /api/pharmacy/prescription-list/search_patient/?q=<search_term>
        """
        search_query = request.query_params.get('q', '')
        if not search_query or len(search_query) < 2:
            return Response(
                {"error": "Please provide at least 2 characters for search"}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Find patients matching the search query
        patients = Patient.objects.filter(
            Q(user__first_name__icontains=search_query) | 
            Q(user__last_name__icontains=search_query) |
            Q(id__iexact=search_query)
        ).select_related('user')
        
        # Get pending prescriptions for these patients
        prescriptions = Prescription.objects.filter(
            medical_record__patient__in=patients,
            status='pending'
        ).select_related('medical_record__patient__user')
        
        serializer = self.get_serializer(prescriptions, many=True)
        return Response(serializer.data)
