from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .views import (
    UserProfileView, PatientRegistrationView, DoctorRegistrationView, PharmacistRegistrationView,
    LogoutView, PatientListView, DoctorListView, PharmacistListView,DoctorProfileView,PharmacistProfileView,PatientProfileView
)

urlpatterns = [
    # JWT Authentication
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('logout/', LogoutView.as_view(), name='logout'),
    
    # User Registration
    path('register/patient/', PatientRegistrationView.as_view(), name='patient_register'),
    path('register/doctor/', DoctorRegistrationView.as_view(), name='doctor_register'),
    path('register/pharmacist/', PharmacistRegistrationView.as_view(), name='pharmacist_register'),
    
    # User Profile
    path('profile/', UserProfileView.as_view(), name='user_profile'),
    
    # List Users
    path('patients/', PatientListView.as_view(), name='patient_list'),
    path('doctors/', DoctorListView.as_view(), name='doctor_list'),
    path('pharmacists/', PharmacistListView.as_view(), name='pharmacist_list'),
    path('doctors/me/', DoctorProfileView.as_view(), name='doctor_profile_me'),
    path('pharmacists/me/', PharmacistProfileView.as_view(), name='pharmacist_profile_me'),
    path('patients/me/', PatientProfileView.as_view(), name='patient_profile_me'),         
]