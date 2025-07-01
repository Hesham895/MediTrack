from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager

class UserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('role', User.ADMIN)
        
        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')
        
        return self.create_user(email, password, **extra_fields)

class User(AbstractUser):
    # Role choices
    PATIENT = 'patient'
    DOCTOR = 'doctor'
    PHARMACIST = 'pharmacist'
    ADMIN = 'admin'
    
    ROLE_CHOICES = [
        (PATIENT, 'Patient'),
        (DOCTOR, 'Doctor'),
        (PHARMACIST, 'Pharmacist'),
        (ADMIN, 'Admin'),
    ]
    
    username = None  # Remove username field
    email = models.EmailField(unique=True)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default=PATIENT)
    phone_number = models.CharField(max_length=15, blank=True, null=True)
    date_of_birth = models.DateField(blank=True, null=True)
    profile_picture = models.ImageField(upload_to='profile_pictures/', blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['first_name', 'last_name']
    
    objects = UserManager()
    
    def __str__(self):
        return f"{self.get_full_name()} ({self.email})"
    
    @property
    def is_patient(self):
        return self.role == self.PATIENT
        
    @property
    def is_doctor(self):
        return self.role == self.DOCTOR
        
    @property
    def is_pharmacist(self):
        return self.role == self.PHARMACIST

class Doctor(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='doctor_profile')
    license_number = models.CharField(max_length=50, unique=True)
    specialization = models.CharField(max_length=100)
    hospital_name = models.CharField(max_length=255, blank=True, null=True)
    
    def __str__(self):
        return f"Dr. {self.user.get_full_name()} ({self.specialization})"

class Patient(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='patient_profile')
    blood_group = models.CharField(max_length=5, blank=True, null=True)
    allergies = models.TextField(blank=True, null=True)
    emergency_contact_name = models.CharField(max_length=100, blank=True, null=True)
    emergency_contact_number = models.CharField(max_length=15, blank=True, null=True)
    
    def __str__(self):
        return f"Patient: {self.user.get_full_name()}"

class Pharmacist(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='pharmacist_profile')
    license_number = models.CharField(max_length=50, unique=True)
    pharmacy_name = models.CharField(max_length=255)
    pharmacy_address = models.TextField()
    
    def __str__(self):
        return f"Pharmacist: {self.user.get_full_name()} ({self.pharmacy_name})"
