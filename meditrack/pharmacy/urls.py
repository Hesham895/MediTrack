from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import PharmacyViewSet, PharmacyLogViewSet

router = DefaultRouter()
router.register(r'prescriptions', PharmacyViewSet, basename='pharmacy')
router.register(r'logs', PharmacyLogViewSet, basename='pharmacy-log')

urlpatterns = [
    path('', include(router.urls)),
]