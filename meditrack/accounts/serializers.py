from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import Doctor, Patient, Pharmacist

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'email', 'first_name', 'last_name', 'role', 'phone_number', 
                  'date_of_birth', 'profile_picture', 'created_at')
        read_only_fields = ('created_at',)

class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    confirm_password = serializers.CharField(write_only=True)
    
    class Meta:
        model = User
        fields = ('email', 'first_name', 'last_name', 'password', 'confirm_password', 
                  'role', 'phone_number', 'date_of_birth', 'profile_picture')
    
    def validate(self, data):
        if data['password'] != data.pop('confirm_password'):
            raise serializers.ValidationError("Passwords do not match.")
        return data
    
    def create(self, validated_data):
        return User.objects.create_user(**validated_data)

class PatientSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    
    class Meta:
        model = Patient
        fields = ('id', 'user', 'blood_group', 'allergies', 
                  'emergency_contact_name', 'emergency_contact_number')

class PatientRegistrationSerializer(serializers.ModelSerializer):
    user = UserRegistrationSerializer()
    
    class Meta:
        model = Patient
        fields = ('user', 'blood_group', 'allergies', 
                  'emergency_contact_name', 'emergency_contact_number')
    
    def create(self, validated_data):
        user_data = validated_data.pop('user')
        user_data['role'] = User.PATIENT
        user = User.objects.create_user(**user_data)
        patient = Patient.objects.create(user=user, **validated_data)
        return patient

class DoctorSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    
    class Meta:
        model = Doctor
        fields = ('id', 'user', 'license_number', 'specialization', 'hospital_name')

class DoctorRegistrationSerializer(serializers.ModelSerializer):
    user = UserRegistrationSerializer()
    
    class Meta:
        model = Doctor
        fields = ('user', 'license_number', 'specialization', 'hospital_name')
    
    def create(self, validated_data):
        user_data = validated_data.pop('user')
        user_data['role'] = User.DOCTOR
        user = User.objects.create_user(**user_data)
        doctor = Doctor.objects.create(user=user, **validated_data)
        return doctor

class PharmacistSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    
    class Meta:
        model = Pharmacist
        fields = ('id', 'user', 'license_number', 'pharmacy_name', 'pharmacy_address')

class PharmacistRegistrationSerializer(serializers.ModelSerializer):
    user = UserRegistrationSerializer()
    
    class Meta:
        model = Pharmacist
        fields = ('user', 'license_number', 'pharmacy_name', 'pharmacy_address')
    
    def create(self, validated_data):
        user_data = validated_data.pop('user')
        user_data['role'] = User.PHARMACIST
        user = User.objects.create_user(**user_data)
        pharmacist = Pharmacist.objects.create(user=user, **validated_data)
        return pharmacist