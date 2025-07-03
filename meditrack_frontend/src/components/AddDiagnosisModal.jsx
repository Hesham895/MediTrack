import React, { useState } from 'react';
import '../styles/modal.css'; 

export default function AddDiagnosisModal({ patient, onClose, onSubmit }) {
  const [diagnosis, setDiagnosis] = useState('');
  const [symptoms, setSymptoms] = useState('');
  const [notes, setNotes] = useState('');
  const [treatment, setTreatment] = useState('');

  const handleSubmit = () => {
    if (!diagnosis || !symptoms || !treatment) {
      alert('Diagnosis, symptoms, and treatment plan are required.');
      return;
    }

    onSubmit({
      patient: patient.id,
      diagnosis,
      symptoms,
      notes,
      treatment_plan: treatment
    });

    onClose();
  };

  return (
    <div className="modal-backdrop">
      <div className="modal-box">
        <h3>Add Diagnosis for {patient.user.first_name} {patient.user.last_name}</h3>

        <input className="search-bar-input"
          type="text"
          placeholder="Diagnosis"
          value={diagnosis}
          onChange={(e) => setDiagnosis(e.target.value)}
        />
        <textarea
          placeholder="Symptoms"
          value={symptoms}
          onChange={(e) => setSymptoms(e.target.value)}
        />
        <textarea
          placeholder="Notes (optional)"
          value={notes}
          onChange={(e) => setNotes(e.target.value)}
        />
        <textarea
          placeholder="Treatment Plan"
          value={treatment}
          onChange={(e) => setTreatment(e.target.value)}
        />

        <div className="modal-actions">
          <button className = "search-button" onClick={handleSubmit}>Submit</button>
          <button className = "search-button" onClick={onClose}>Cancel</button>
        </div>
      </div>
    </div>
  );
}