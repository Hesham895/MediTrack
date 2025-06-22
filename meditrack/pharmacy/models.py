from django.db import models
from accounts.models import Pharmacist
from medical.models import Prescription

class PharmacyLog(models.Model):
    pharmacist = models.ForeignKey(Pharmacist, on_delete=models.CASCADE, related_name='pharmacy_logs')
    prescription = models.ForeignKey(Prescription, on_delete=models.CASCADE, related_name='pharmacy_logs')
    notes = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"Log by {self.pharmacist.user.get_full_name()} - {self.prescription}"
