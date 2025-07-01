from rest_framework import viewsets, permissions, status
from rest_framework.response import Response
from rest_framework.decorators import action
from django.shortcuts import get_object_or_404

from .models import PharmacyLog
from .serializers import PharmacyLogSerializer, PrescriptionFillSerializer
from accounts.permissions import IsPharmacist
from medical.models import Prescription
from accounts.models import Pharmacist

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
