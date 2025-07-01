from rest_framework import permissions
from accounts.models import User

class IsPatientOwner(permissions.BasePermission):
    """
    Custom permission to only allow patients to view their own records.
    """
    def has_object_permission(self, request, view, obj):
        # Check if user is a patient and the record belongs to them
        if request.user.is_patient:
            return obj.patient.user == request.user
        return False

class IsDoctorOwnerOrPatientReadOnly(permissions.BasePermission):
    """
    Custom permission to only allow doctors who created the record to edit it,
    and patients to whom the record belongs to view it.
    """
    def has_object_permission(self, request, view, obj):
        # Read permissions are allowed to patients who own the record
        if request.method in permissions.SAFE_METHODS and request.user.is_patient:
            return obj.patient.user == request.user
            
        # Write permissions are only allowed to the doctor who created the record
        return request.user.is_doctor and obj.doctor.user == request.user