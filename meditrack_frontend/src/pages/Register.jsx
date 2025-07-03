
import React, { useState } from "react";
import SharedUserFields from "../components/SharedUserFields";
import PatientFields from "../components/RoleFields/PatientFields";
import DoctorFields from "../components/RoleFields/DoctorFields";
import PharmacistFields from "../components/RoleFields/PharmacistFields";
import "../styles/auth.css";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import { AuthService } from '../services/authService';

export default function Register() {
  const [user, setUser] = useState({
    email: "",
    first_name: "",
    last_name: "",
    password: "",
    confirm_password: "",
    role: "patient",
    phone_number: "",
    date_of_birth: "",
    profile_picture: null,
  });

  const [extra, setExtra] = useState({});
  const navigate = useNavigate();

const handleSubmit = async (e) => {
  e.preventDefault();

  const fixedUser = {
    ...user,
    date_of_birth: user.date_of_birth || null,
    profile_picture: user.profile_picture || null,
    role: user.role || null,
  };

  const payload = {
    user: fixedUser,
    ...extra,
  };

  const endpointMap = {
    patient: "http://127.0.0.1:8000/api/auth/register/patient/",
    doctor: "http://127.0.0.1:8000/api/auth/register/doctor/",
    pharmacist: "http://127.0.0.1:8000/api/auth/register/pharmacist/",
  };


  await AuthService.register(endpointMap[user.role], payload);
  navigate("/login");

};
  return (
    <div className="auth-container">
      <div className="auth-box">
        <h2>Register</h2>
        <form onSubmit={handleSubmit}>
          <SharedUserFields user={user} setUser={setUser} />

          {user.role === "patient" && <PatientFields extra={extra} setExtra={setExtra} />}
          {user.role === "doctor" && <DoctorFields extra={extra} setExtra={setExtra} />}
          {user.role === "pharmacist" && <PharmacistFields extra={extra} setExtra={setExtra} />}

          <button className="auth-button" type="submit">
            Register
          </button>
        </form>
      </div>
    </div>
  );
}
