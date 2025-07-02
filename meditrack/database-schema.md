# MediTrack Database Schema
Current Date and Time (UTC - YYYY-MM-DD HH:MM:SS formatted): 2025-07-02 18:01:45
Current User's Login: Abdalla Rabea Mabed

```mermaid
erDiagram
    USER {
        int id PK
        string email UK
        string first_name
        string last_name
        string password
        enum role "patient/doctor/pharmacist/admin"
        string phone_number
        date date_of_birth
        string profile_picture
        datetime created_at
        datetime updated_at
        boolean is_active
        boolean is_staff
        boolean is_superuser
    }

    PATIENT {
        int id PK
        int user_id FK
        string blood_group
        text allergies
        string emergency_contact_name
        string emergency_contact_number
    }

    DOCTOR {
        int id PK
        int user_id FK
        string license_number UK
        string specialization
        string hospital_name
    }

    PHARMACIST {
        int id PK
        int user_id FK
        string license_number UK
        string pharmacy_name
        text pharmacy_address
    }

    MEDICAL_RECORD {
        int id PK
        int patient_id FK
        int doctor_id FK
        text diagnosis
        text symptoms
        text notes
        datetime created_at
        datetime updated_at
    }

    PRESCRIPTION {
        int id PK
        int medical_record_id FK
        enum status "pending/filled/cancelled"
        datetime filled_date
        datetime created_at
        datetime updated_at
    }

    MEDICATION {
        int id PK
        int prescription_id FK
        string name
        string dosage
        string frequency
        string duration
        text instructions
    }

    PHARMACY_LOG {
        int id PK
        int pharmacist_id FK
        int prescription_id FK
        text notes
        datetime created_at
    }

    USER ||--o| PATIENT : "has"
    USER ||--o| DOCTOR : "has"
    USER ||--o| PHARMACIST : "has"
    
    PATIENT ||--o{ MEDICAL_RECORD : "has"
    DOCTOR ||--o{ MEDICAL_RECORD : "creates"
    
    MEDICAL_RECORD ||--o{ PRESCRIPTION : "has"
    PRESCRIPTION ||--o{ MEDICATION : "contains"
    
    PHARMACIST ||--o{ PHARMACY_LOG : "creates"
    PRESCRIPTION ||--o{ PHARMACY_LOG : "referenced in"