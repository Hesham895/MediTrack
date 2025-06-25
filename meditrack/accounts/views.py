from rest_framework import generics, status, filters
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import get_user_model
from .serializers import (
    UserSerializer, PatientRegistrationSerializer, DoctorRegistrationSerializer, 
    PharmacistRegistrationSerializer, PatientSerializer, DoctorSerializer, PharmacistSerializer
)
from .models import Patient, Doctor, Pharmacist
from .permissions import IsPatient, IsDoctor, IsPharmacist

User = get_user_model()

class UserProfileView(generics.RetrieveUpdateAPIView):
    serializer_class = UserSerializer
    permission_classes = (IsAuthenticated,)
    
    def get_object(self):
        return self.request.user

class PatientRegistrationView(generics.CreateAPIView):
    serializer_class = PatientRegistrationSerializer
    permission_classes = (AllowAny,)

class DoctorRegistrationView(generics.CreateAPIView):
    serializer_class = DoctorRegistrationSerializer
    permission_classes = (AllowAny,)

class PharmacistRegistrationView(generics.CreateAPIView):
    serializer_class = PharmacistRegistrationSerializer
    permission_classes = (AllowAny,)

class LogoutView(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        try:
            refresh_token = request.data["refresh"]
            token = RefreshToken(refresh_token)
            token.blacklist()
            return Response(status=status.HTTP_205_RESET_CONTENT)
        except Exception as e:
            return Response(status=status.HTTP_400_BAD_REQUEST)

class PatientListView(generics.ListAPIView):
    permission_classes = (IsDoctor,)
    serializer_class = PatientSerializer
    queryset = Patient.objects.all()
    filter_backends = [filters.SearchFilter]
    # Allow search by id, first name, and last name
    search_fields = ['id', 'user__first_name', 'user__last_name']

class DoctorListView(generics.ListAPIView):
    permission_classes = (IsAuthenticated,)
    serializer_class = DoctorSerializer
    queryset = Doctor.objects.all()
    filter_backends = [filters.SearchFilter]
    # Allow search by id, first name, and last name
    search_fields = ['id', 'user__first_name', 'user__last_name']

class PharmacistListView(generics.ListAPIView):
    permission_classes = (IsAuthenticated,)
    serializer_class = PharmacistSerializer
    queryset = Pharmacist.objects.all()
    filter_backends = [filters.SearchFilter]
    # Allow search by id, first name, and last name
    search_fields = ['id', 'user__first_name', 'user__last_name']
