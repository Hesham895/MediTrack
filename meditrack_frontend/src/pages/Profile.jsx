
import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useLocation } from 'react-router-dom';
import '../styles/profile.css';

export default function ProfilePage() {
  const { state } = useLocation();
  const { role, id } = state || {};

  const [profile, setProfile] = useState(null);

  useEffect(() => {
    if (!role || !id) return;

    const fetchProfile = async () => {
      try {
        const accessToken = localStorage.getItem('accessToken');
        const response = await axios.get(`http://127.0.0.1:8000/api/auth/${role}s/me/`, {
          headers: {
            Authorization: `Bearer ${accessToken}`,
          },
        });
        setProfile(response.data);
      } catch (error) {
        console.error('Failed to fetch profile:', error);
      }
    };

    fetchProfile();
  }, [role, id]);

  if (!profile) return <p>Loading profile...</p>;
  
  const { first_name, last_name, email, phone_number, date_of_birth, profile_picture } = profile.user;
  
  return (
    <div className="profile-container">
      <div className="profile-card">
        <img
          src={profile_picture || '/user.png'}
          
          alt="User profile"
          className="profile-image"
        />
        <h2>{first_name} {last_name}</h2>
        <p className="role-label">{role.toUpperCase()}</p>

        <div className="profile-info">
          <p className='profile-info-label'><strong>Email:</strong> {email}</p>
          <p className='profile-info-label'><strong>Phone:</strong> {phone_number}</p>
          <p className='profile-info-label'><strong>Date of Birth:</strong> {date_of_birth}</p>

          {role === 'patient' && (
            <>
              <p className='profile-info-label'><strong >Blood Group:</strong> {profile.blood_group}</p>
              <p className='profile-info-label'><strong>Allergies:</strong> {profile.allergies}</p>
              <p className='profile-info-label'><strong>Emergency Contact:</strong> {profile.emergency_contact_name} ({profile.emergency_contact_number})</p>
            </>
          )}

          {role === 'doctor' && (
            <>
              <p className='profile-info-label'><strong>License Number:</strong> {profile.license_number}</p>
              <p className='profile-info-label'><strong>Specialization:</strong> {profile.specialization}</p>
              <p className='profile-info-label'><strong>Hospital Name:</strong> {profile.hospital_name}</p>
            </>
          )}

          {role === 'pharmacist' && (
            <>
              <p><strong>License Number:</strong> {profile.license_number}</p>
              <p><strong>Pharmacy Name:</strong> {profile.pharmacy_name}</p>
              <p><strong>Pharmacy Address:</strong> {profile.pharmacy_address}</p>
            </>
          )}
        </div>
      </div>
    </div>
  );
}
