import React, { useState } from "react";
import "../styles/searchModal.css";

export default function SearchModal({ type, data, onClose }) {
  const [query, setQuery] = useState("");

  const queryLower = query.toLowerCase();

  const matches = data.filter((item) => {
    if (type === "prescriptions") {
      return (
        item.medications?.some((m) => m.name.toLowerCase().includes(queryLower)) ||
        item.status?.toLowerCase().includes(queryLower) ||
        item.recordDiagnosis?.toLowerCase().includes(queryLower) ||
        item.created_at?.toLowerCase().includes(queryLower)
      );
    } else if (type === "pharmacistPrescriptions") {
      return (
        item.notes?.toLowerCase().includes(queryLower) ||
        item.created_at?.toLowerCase().includes(queryLower)
      );
    } else if (type === "doctorRecords") {
      return (
        String(item.patient)?.includes(queryLower) ||
        item.diagnosis?.toLowerCase().includes(queryLower) ||
        item.symptoms?.toLowerCase().includes(queryLower) ||
        item.notes?.toLowerCase().includes(queryLower) ||
        item.created_at?.toLowerCase().includes(queryLower)
      );
    }
     else {
      return (
        item.diagnosis?.toLowerCase().includes(queryLower) ||
        item.symptoms?.toLowerCase().includes(queryLower) ||
        item.treatment_plan?.toLowerCase().includes(queryLower) ||
        item.doctor_name?.toLowerCase().includes(queryLower) ||
        item.created_at?.toLowerCase().includes(queryLower)
      );
    }
  });

    const getTitle = () => {
    switch (type) {
      case "prescriptions":
        return "Search Prescriptions";
      case "pharmacistPrescriptions":
        return "Search Pharmacist-Filled Prescriptions";
      case "doctorRecords":
        return "Search Doctor Records";
      default:
        return "Search Medical Records";
    }
  };

  return (
    <div className="search-modal-overlay">
      <div className="search-modal">
        <div className="modal-header">
          <h3>{getTitle()}</h3>
          <button onClick={onClose} className="close-btn">&times;</button>
        </div>

        <input
          type="text"
          placeholder="Type to search..."
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          className="search-input"
        />

        <div className="search-results">
          {matches.length === 0 ? (
            <p>No matches found.</p>
          ) : (
            matches.map((item, i) => (
              <div key={i} className="result-item">
                {type === "prescriptions" ? (
                  <>
                    <p><strong>Date:</strong> {new Date(item.created_at).toLocaleDateString()}</p>
                    <p><strong>Status:</strong> {item.status}</p>
                    <p><strong>Diagnosis:</strong> {item.recordDiagnosis}</p>
                    <p><strong>Medications:</strong> {item.medications?.map((m) => m.name).join(", ")}</p>
                  </>
                ) : type === "pharmacistPrescriptions" ? (
                  <>
                    <p><strong>Date:</strong> {new Date(item.created_at).toLocaleDateString()}</p>
                    <p><strong>Prescription ID:</strong> {item.prescription}</p>
                    <p><strong>Notes:</strong> {item.notes || "—"}</p>
                  </>
                ) : type === "doctorRecords" ? (
                  <>
                    <p><strong>Date:</strong> {new Date(item.created_at).toLocaleDateString()}</p>
                    <p><strong>Patient ID:</strong> {item.patient}</p>
                    <p><strong>Diagnosis:</strong> {item.diagnosis}</p>
                    <p><strong>Symptoms:</strong> {item.symptoms}</p>
                    <p><strong>Notes:</strong> {item.notes || "—"}</p>
                  </>
                ) : (
                  <>
                    <p><strong>Date:</strong> {new Date(item.created_at).toLocaleDateString()}</p>
                    <p><strong>Diagnosis:</strong> {item.diagnosis}</p>
                    <p><strong>Doctor:</strong> {item.doctor_name || "Unknown"}</p>
                    <p><strong>Symptoms:</strong> {item.symptoms}</p>
                  </>
                )}
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}

