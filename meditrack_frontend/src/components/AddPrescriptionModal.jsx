import React, { useState } from 'react';
import axios from 'axios';
import "../styles/modal.css"; 


export default function AddPrescriptionModal({ medicalRecordId, onClose }) {
  const [medications, setMedications] = useState([
    { name: '', dosage: '', frequency: '', duration: '', instructions: '' },
  ]);

  const handleChange = (index, e) => {
    const { name, value } = e.target;
    const updated = [...medications];
    updated[index][name] = value;
    setMedications(updated);
  };

  const addMedication = () => {
    setMedications([...medications, { name: '', dosage: '', frequency: '', duration: '', instructions: '' }]);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const token = localStorage.getItem('accessToken');
    
    try {
      const res = await axios.post('http://127.0.0.1:8000/api/medical/prescriptions/', {
        medical_record: medicalRecordId,
        medications,
      }, 
      {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });
      

      alert("Prescription added successfully.");
      onClose();
    } catch (err) {
      console.error("Prescription error:", err.response?.data || err.message);
      alert("Failed to add prescription: " + JSON.stringify(err.response?.data || err.message));
    }
  };

  return (
    <div className="modal-overlay">
      <div className="modal-box">
        <h3>Add Prescription</h3>
        <form onSubmit={handleSubmit}>
          {medications.map((med, idx) => (
            <div key={idx} className="medication-group">
              <input className = "search-input" name="name" placeholder="Medication Name" value={med.name} onChange={(e) => handleChange(idx, e)} required />
              <input className = "search-input" name="dosage" placeholder="Dosage" value={med.dosage} onChange={(e) => handleChange(idx, e)} required />
              <input className = "search-input" name="frequency" placeholder="Frequency" value={med.frequency} onChange={(e) => handleChange(idx, e)} required />
              <input className = "search-input" name="duration" placeholder="Duration" value={med.duration} onChange={(e) => handleChange(idx, e)} required />
              <input className = "search-input" name="instructions" placeholder="Instructions (optional)" value={med.instructions} onChange={(e) => handleChange(idx, e)} />
            </div>
          ))}

          <button className="search-icon-btn" type="button" onClick={addMedication}>+ Add Another Medication</button>
          <div className="modal-buttons">
            <button type="submit" className = "search-button">Submit Prescription</button>
            <button type="button" onClick={onClose} className = "search-button">Cancel</button>
          </div>
        </form>
      </div>
    </div>
  );
}
