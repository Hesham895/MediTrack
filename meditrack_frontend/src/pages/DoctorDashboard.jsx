import React, { useState, useEffect } from 'react';
import "../styles/doctorDashboard.css";
import AddDiagnosisModal from '../components/AddDiagnosisModal';
import AddPrescriptionModal from '../components/AddPrescriptionModal';
import ProfileSection from "../components/ProfileSection";
import { DoctorService } from '../services/doctorService';
import SearchModal from "../components/SearchModal";

export default function DoctorDashboard() {
  const [doctor, setDoctor] = useState(null);
  const [search, setSearch] = useState('');
  const [patients, setPatients] = useState([]);
  const [selectedPatient, setSelectedPatient] = useState(null);
  const [showModal, setShowModal] = useState(false);
  const [lastMedicalRecord, setLastMedicalRecord] = useState(null);
  const [showPrescriptionModal, setShowPrescriptionModal] = useState(false);
  const [myRecords, setMyRecords] = useState([]);

    const [showSearchModal, setShowSearchModal] = useState(false);
      const [searchType, setSearchType] = useState(""); 

useEffect(() => {
  const fetchDoctorData = async () => {
    const res = await DoctorService.getDoctor();
    const doctorData = res.data;
    setDoctor(doctorData);

    const Res = await DoctorService.getMedicalRecord();
    setMyRecords(Res.data.results);       
  };

  fetchDoctorData();
}, []);

  const handleSearch = async () => {
    const res = await DoctorService.searchPatient(search);
    setPatients(res.data.results); 
  };

  const handleCreateMedicalRecord = async (data) => {

    const Payload = {
      ...data,
      doctor: doctor.id, 
    };
    
    const res = await DoctorService.createMedicalRecord(Payload);
    const record = res.data;
    setLastMedicalRecord(record);

  };
  const openSearch = (type) => {
    setSearchType(type);
    setShowSearchModal(true);
  };

  return (
  <div className="dashboard">
    <header className="dashboard-header1">
      <ProfileSection />
    </header>

    <div className="dashboard-main">
      <div className="search-patient-section">
        <h3>Search Patients</h3>
        <div className="search-bar">
          <input className="search-bar-input"
            type="text"
            placeholder="Enter patient name or ID..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
          <button className="search-button" onClick={handleSearch}>Search</button>
        </div>

        {patients.length > 0 && (
        <div className="modal-overlay">
          <div className="modal-content">
            <div className="modal-header">
              <h3>Search Results</h3>
              <button className="close-btn" onClick={() => setPatients([])}>&times;</button>
            </div>
            <ul className="patient-list">
              {patients.map((p) => (
                <li
                  key={p.id}
                  onClick={() => {
                    setSelectedPatient(p);
                    setPatients([]); 
                  }}
                  className={selectedPatient?.id === p.id ? 'selected' : ''}
                >
                  {p.user.first_name} {p.user.last_name} — ID: {p.id}
                </li>
              ))}
            </ul>
          </div>
        </div>
      )}

        
        {selectedPatient ? (
          <>
            <div className="search-patient-info">
            <h3 >Patient Info</h3>
            <p><strong className="label-patient">Name:</strong> {selectedPatient.user.first_name} {selectedPatient.user.last_name}</p>
            <p><strong className="label-patient">Email:</strong> {selectedPatient.user.email}</p>           
            <p><strong className="label-patient">Phone:</strong> {selectedPatient.user.phone_number}</p>
            {/*
            <button className="add-button" onClick={() => setShowModal(true)}>Add Diagnosis</button>
            */}
            <div className="button-row">
        <button className="medical-button" onClick={() => setShowModal(true)}>Add Diagnosis</button>
        <button className="medical-button" onClick={() => setShowPrescriptionModal(true)}>
               Add Prescription
        </button>
        </div>
            </div>
          </>
        ) : (
          <p className="no-patient-placeholder">Search to view patient details</p>
        )}
        
        
        
        {/*
        {lastMedicalRecord && (
          <div className="prescription-created">
            
            
            <button className="add-button" onClick={() => setShowPrescriptionModal(true)}>
              💊 Add Prescription
            </button>
            <h3> to Medical Record #{lastMedicalRecord.id}</h3>
          </div>
        )}
        */}
      </div>

  <div className="history-section">
    <div className="search-prescription-records">
      <h3 className='record-search-title'>My Medical Records</h3>

     <button className="search-icon-btn" onClick={() => openSearch("prescriptions")}>🔍</button>
      </div>
  
  {myRecords.length > 0 ? (
    <div className="record-box-scroll">
      {myRecords.map((record) => (
        <div key={record.id} className="record-card">
        <div className="record-info">
          <p><span className="label">Patient ID:</span> {record.patient}</p>
          <p><span className="label">Diagnosis:</span> {record.diagnosis}</p>
          <p><span className="label">Symptoms:</span> {record.symptoms}</p>
          <p><span className="label">Notes:</span> {record.notes}</p>
          <p><span className="label">Treatmeant Plan:</span></p>
          <p><span className="label">Date:</span> {new Date(record.created_at).toLocaleString()}</p>
        </div>

        <div className="prescription-section">
          
      <h4>Prescriptions</h4>

      
          
          {record.prescriptions && record.prescriptions.length > 0 ? (
            record.prescriptions.map((prescription) => (
              <div key={prescription.id} className="prescription-card">
                {prescription.medications && prescription.medications.length > 0 ? (
                  prescription.medications.map((med, idx) => (
                    <div key={idx} className="medication-item">
                      <p><strong className="label">Medication:</strong> {med.name}</p>
                      <p><strong className="label">Dosage:</strong> {med.dosage}</p>
                      <p><strong className="label">Frequency:</strong> {med.frequency}</p>
                      <p><strong className="label">Duration:</strong> {med.duration}</p>
                      <p><strong className="label">Instructions:</strong> {med.instructions}</p>
                    </div>
                    
                    ))
                  ) : (
                    <p className="no-medications">No medications listed.</p>
                  )}
                  <p></p>
                </div>
              ))
            ) : (
              <p className="no-prescriptions"><em>No prescriptions for this record.</em></p>
            )}
          </div>
        </div>
      ))}
    </div>
    ) : (
    <p>No records yet.</p>
    )}
    </div>
    </div>

    {showModal && selectedPatient && (
      <AddDiagnosisModal
        patient={selectedPatient}
        onClose={() => setShowModal(false)}
        onSubmit={handleCreateMedicalRecord}
      />
    )}
    

    {showPrescriptionModal && lastMedicalRecord && (
      <AddPrescriptionModal
        medicalRecordId={lastMedicalRecord.id}
        onClose={() => setShowPrescriptionModal(false)}
      />
    )}
    {showSearchModal && (
                  <SearchModal
                    type="doctorRecords"
                    data={myRecords}
                    onClose={() => setShowSearchModal(false)}
                  />
                )}
    <footer className="app-footer">
      <p>© 2025 MediTrack — Empowering Doctors, Patients, and Pharmacists.</p>
    </footer>
  </div>
);


}
