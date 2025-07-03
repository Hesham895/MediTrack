// src/pages/PatientDashboard.jsx
import React, { useEffect, useState } from "react";
import { patientService } from '../services/patientService';
import axios from "axios";
import "../styles/patientDashboard.css";

import { useNavigate } from 'react-router-dom';
import ProfileSection from "../components/ProfileSection";
import SearchModal from "../components/SearchModal";



export default function PatientDashboard() {
  const [patientData, setPatientData] = useState(null);
  const [prescriptions, setPrescriptions] = useState([]);
  const [records, setRecords] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedRecordId, setSelectedRecordId] = useState(null);
  const [selectedPrescriptionId, setSelectedPrescriptionId] = useState(null);



  const [showSearchModal, setShowSearchModal] = useState(false);
  const [searchType, setSearchType] = useState(""); 



  useEffect(() => {
    const fetchPatientDashboard = async () => {
      try {
        const data = await patientService.getDashboard();
        setPatientData(data);
        setLoading(false);
      } catch (err) {
        console.error("Error fetching dashboard:", err);
        setLoading(false); 
      }
    };
    fetchPatientDashboard();
  }, []);


  
  useEffect(() => {
  if (!patientData) return; 
  const fetchRecords = async () => {
    try {
      const res = await patientService.getMedicalRecords(patientData.id)
      setRecords(res.data.results || []); 
    } catch (err) {
      console.error("Failed to fetch records:", err);
    } finally {
      setLoading(false);
    }
  };
  fetchRecords();
  }, [patientData]);


  useEffect(() => {
    const fetchPrescriptions = async () => {
      try {
        const res = await patientService.getPrescriptions();
        setPrescriptions(res.data.results || []);
      } catch (err) {
        console.error("Failed to fetch prescriptions:", err);
      }
    };
    fetchPrescriptions();
  }, []);

    const openSearch = (type) => {
    setSearchType(type);
    setShowSearchModal(true);
  };


  if (loading) return <p>Loading...</p>;
  if (!patientData) return <p>Error loading data.</p>;


const flattenedPrescriptions = records.flatMap(record =>
  (record.prescriptions || []).map(p => ({
    ...p,
    recordDiagnosis: record.diagnosis,
    recordCreatedAt: record.created_at,
    doctor_name: record.doctor_name,
    symptoms: record.symptoms,
  }))
);
  return (
    <div className="patient-dashboard">
  <header>
    <ProfileSection />
  </header>

  <div className="patient-dashboard-main">
    <section className="patient-section patient-prescriptions-section">
      <div className="search-prescription-records">
      <h3>Prescriptions</h3>

      <button className="search-icon-btn" onClick={() => openSearch("prescriptions")}>🔍</button>
      </div>
      {records && records.some(record => record.prescriptions?.length > 0) ? (
        <div className="patient-scroll-box">
          {[...records]
            .flatMap(record =>
              (record.prescriptions || []).map(prescription => ({
                ...prescription,
                recordDiagnosis: record.diagnosis,
                recordCreatedAt: record.created_at,
              }))
            )
            .sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
            .map(prescription => {
              const isExpanded = selectedPrescriptionId === prescription.id;
              return (
                <div key={prescription.id} className="patient-record-container">
                  <div
                    className={`patient-prescription-header ${isExpanded ? "expanded" : ""}`}
                    onClick={() =>
                      setSelectedPrescriptionId(isExpanded ? null : prescription.id)
                    }
                  >
                    <span><strong>{new Date(prescription.created_at).toLocaleDateString()}</strong></span>
                    <span>Status: {prescription.status}</span>
                    <span>Diagnosis: {prescription.recordDiagnosis}</span>
                    <span>{isExpanded ? "▲" : "▼"}</span>
                  </div>

                  {isExpanded && (
                    <div className="patient-record-details">
                      {prescription.medications?.length > 0 ? (
                        prescription.medications.map((med, index) => (
                          <div key={index} className="patient-medication">
                            <p><strong className="label">Medication:</strong> {med.name}</p>
                            <p><strong className="label">Dosage:</strong> {med.dosage}</p>
                            <p><strong className="label">Frequency:</strong> {med.frequency}</p>
                            <p><strong className="label">Duration:</strong> {med.duration}</p>
                            <p><strong className="label">Instructions:</strong> {med.instructions || "N/A"}</p>
                          </div>
                        ))
                      ) : (
                        <p>No medications listed.</p>
                      )}
                    </div>
                  )}
                </div>
              );
            })}
        </div>
      ) : (
        <p>No prescriptions available.</p>
      )}
    </section>

    <section className="patient-section patient-records-section">
      <div className="search-prescription-records">
      <h3>Medical Records</h3>

      <button className="search-icon-btn" onClick={() => openSearch("records")}>🔍</button>
      </div>
      {records && records.length > 0 ? (
        <div className="patient-scroll-box">
          {records.map(record => {
            const isExpanded = selectedRecordId === record.id;
            return (
              <div key={record.id} className="patient-record-container">
                <div
                  className={`patient-record-header ${isExpanded ? 'expanded' : ''}`}
                  onClick={() =>
                    setSelectedRecordId(isExpanded ? null : record.id)
                  }
                >
                  <span><strong>{new Date(record.created_at).toLocaleDateString()}</strong></span>
                  <span>{record.diagnosis}</span>
                  <span>Dr. {record.doctor_name || "Unknown"}</span>
                  <span>{isExpanded ? "▲" : "▼"}</span>
                </div>

                {isExpanded && (
                  <div className="patient-record-details">
                    <p><strong className="label">Diagnosis:</strong> {record.diagnosis}</p>
                    <p><strong className="label">Symptoms:</strong> {record.symptoms}</p>
                    <p><strong className="label">Notes:</strong> {record.notes}</p>
                    <p><strong className="label">Treatment Plan:</strong> Start Amlodipine 5mg, once daily, Recommend DASH diet (low sodium), Daily brisk walking (30 minutes), Follow-up visit in 2 weeks for BP monitoring</p>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      ) : (
        <p>No medical records available.</p>
      )}
    </section>

      {showSearchModal && (
        <SearchModal
          type={searchType}
          data={searchType === "prescriptions" ? flattenedPrescriptions : records}
          onClose={() => setShowSearchModal(false)}
        />
      )}
      
      
  </div>
  <footer className="app-footer">
  <p>© 2025 MediTrack — Empowering Doctors, Patients, and Pharmacies.</p>
</footer>
</div>

  );
}


