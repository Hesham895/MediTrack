import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Register from "./pages/Register";
import Login from "./pages/Login";
import PatientDashboard from './pages/PatientDashboard';
import Profile from './pages/Profile';

import DoctorDashboard from "./pages/DoctorDashboard";  
import PharmacistDashboard from "./pages/PharmacistDashboard";




function App() {
  return (
    <Router>
      <Routes>
        <Route path="/register" element={<Register />} />
        <Route path="/login" element={<Login />} />
        <Route path="/patient/dashboard" element={<PatientDashboard />} />
        <Route path="/profile" element={<Profile />} />
        <Route path="/doctor/dashboard" element={<DoctorDashboard />} />
        <Route path="/pharmacist/dashboard" element={<PharmacistDashboard />} />
      </Routes>
    </Router>
  );
}

export default App;
