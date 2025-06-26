from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'medical-records', views.MedicalRecordViewSet, basename='medical-record')
router.register(r'prescriptions', views.PrescriptionViewSet, basename='prescription')

urlpatterns = [
    path('', include(router.urls)),
    # Add the new simplified endpoint
    path('create-prescription/', views.create_prescription, name='create-prescription'),
]