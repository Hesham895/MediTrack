from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    PharmacyViewSet,
    PharmacyLogViewSet,
    PharmacistDashboardView,
    PharmacistPrescriptionViewSet
)

router = DefaultRouter()
router.register(r'prescriptions', PharmacyViewSet, basename='pharmacy')
router.register(r'logs', PharmacyLogViewSet, basename='pharmacy-log')
router.register(r'prescription-list', PharmacistPrescriptionViewSet, basename='pharmacist-prescription')

urlpatterns = [
    path('', include(router.urls)),
    path('dashboard/', PharmacistDashboardView.as_view(), name='pharmacist-dashboard'),
]