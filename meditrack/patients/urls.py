from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    PatientDashboardView, PatientMedicalRecordViewSet, PatientPrescriptionsViewSet
)

router = DefaultRouter()
router.register(r'records', PatientMedicalRecordViewSet, basename='patient-record')
router.register(r'prescriptions', PatientPrescriptionsViewSet, basename='patient-prescription')

urlpatterns = [
    path('dashboard/', PatientDashboardView.as_view(), name='patient-dashboard'),
    path('', include(router.urls)),
]