
import React, { useState } from 'react';
import { useNavigate } from "react-router-dom";
import axios from 'axios';
import '../styles/auth.css';
import { AuthService } from '../services/authService';

export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const handleLogin = async (e) => {
  e.preventDefault();

  const resToken = await AuthService.login(email, password);
  const { access, refresh } = resToken.data;

  localStorage.setItem('accessToken', access);
  localStorage.setItem('refreshToken', refresh);

  console.log('Login successful!');

  const resProfile = await AuthService.getProfile();
  const { role } = resProfile.data;

  if (role === 'patient') {
    navigate('/patient/dashboard');
  } else if (role === 'doctor') {
    navigate('/doctor/dashboard');
  } else if (role === 'pharmacist') {
     navigate('/pharmacist/dashboard');
  } else {
    alert('Unknown role, cannot navigate.');
  }
  };

  return (
    <div className="auth-container">
  <h1 className="auth-title">MediTrack</h1> 

  <div className="auth-box">
    <h2>Login</h2>
    <form onSubmit={handleLogin}>
      <input
        className="auth-input"
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
      />
      <input
        className="auth-input"
        type="password"
        placeholder="Password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
      />
      <button className="auth-button" type="submit">Login</button>
    </form>
    <div className="auth-link">
      <p></p>
      Don’t have an account? <a href="/register">Register</a>
    </div>
  </div>
</div>
  );
}
