import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import { useLocation } from 'react-router-dom';
import "../styles/profileSection.css";

export default function ProfileSection() {
  const [profile, setProfile] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchProfile = async () => {
      try {
        const token = localStorage.getItem('accessToken');
        const response = await axios.get('http://127.0.0.1:8000/api/auth/profile/', {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });

        setProfile(response.data);
        
        
      } catch (err) {
        console.error('Failed to load profile:', err);
      }
    };

    fetchProfile();
  }, []);

  if (!profile) return <p>Loading profile...</p>;

  const handleViewFullProfile = () => {
    navigate('/profile', {
    state: {
      role: profile.role,
      id: profile.id,
    },
  });
  };
  const handleLogout = () => {
  localStorage.removeItem('accessToken');
  localStorage.removeItem('refreshToken');
  navigate('/login');
  };

  return (
        <div className="profile-section-card">
          <div className="profile-section-info">
            <img
              src={profile.profile_picture || '/user.png'}
              alt="User profile"
              className="profile-section-avatar"
            />
            <div className="profile-section-name">
              <h2>Hello, <span>{profile.first_name}</span> 👋</h2>
              <p className="role-label">{profile.role?.toUpperCase()}</p>
            </div>
          </div>
          <div className="profile-section-buttons">
            <button className="toggle-profile-section-btn" onClick={handleViewFullProfile}>
              View Profile
            </button>
            <button className="logout-button" onClick={handleLogout}>Logout</button>
          </div>
        </div>

  );
}
