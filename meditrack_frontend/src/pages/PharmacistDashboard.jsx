import React, { useState, useEffect } from 'react';
import { pharmacyService } from '../services/pharmacyService';
import Profile from "../components/ProfileSection";
import '../styles/pharmacistDashboard.css';
import '../styles/dashboard.css';
import SearchModal from "../components/SearchModal";

export default function PharmacyDashboard() {
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState([]);
  const [pharmacyLogs, setPharmacyLogs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [fillNote, setFillNote] = useState('');
  const [selectedPrescription, setSelectedPrescription] = useState(null);
  const [dashboard, setDashboard] = useState(null);

  const [logDetailData, setLogDetailData] = useState(null);
  const [showSearchModal, setShowSearchModal] = useState(false);
    const [searchType, setSearchType] = useState(""); 

  useEffect(() => {
    const loadLogs = async () => {
      setLoading(true);
      try {
        const data = await pharmacyService.getDashboard();
        setDashboard(data.data.filled_prescriptions || []);
      } catch {
        alert('Failed to load pharmacy logs.');
      } finally {
        setLoading(false);
      }
    };

    loadLogs();
  }, []);
  

  useEffect(() => {
    const loadLogs = async () => {
      setLoading(true);
      try {
        const data = await pharmacyService.getPharmacyLogs();
        setPharmacyLogs(data.results || []);
      } catch {
        alert('Failed to load pharmacy logs.');
      } finally {
        setLoading(false);
      }
    };

    loadLogs();
  }, []);

  const handleSearch = async (e) => {
    e.preventDefault();
    if (!searchQuery.trim()) return;
    try {
      const results = await pharmacyService.searchPatient(searchQuery);
      setSearchResults(results);
    } catch {
      alert('Search failed.');
    }
  };

  const fillPrescription = async (id) => {
    try {
      await pharmacyService.fillPrescription(id, fillNote);
      alert('Prescription filled!');
      setFillNote('');
      setSelectedPrescription(null);
      setSearchResults((prev) => prev.filter(p => p.prescription_id !== id));
    } catch {
      alert('Failed to fill prescription.');
    }
  };

 

  const handleShowDetailsFromLog = (prescriptionId) => {
    const matched = dashboard.find(p => String(p.prescription_id) === String(prescriptionId));
    if (matched) {
      setLogDetailData(matched);
    } else {
      alert("Prescription details not found in dashboard.");
    }
  };

      const openSearch = (type) => {
    setSearchType(type);
    setShowSearchModal(true);
  };

 if (loading) return <p>Loading...</p>;
  
  return (
    <div className="pharmacist-dashboard">
      <header className="dashboard-header1">
        <Profile />
      </header>

      <div className="pharmacist-dashboard-main">
        <div className="pharmacist-search-section">
          <h3>Search Prescriptions</h3>
          <form onSubmit={handleSearch} className="pharmacist-search-bar">
            <input
              type="text"
              placeholder="Search by patient name or ID..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pharmacist-search-bar-input"
            />
            <button type="submit" className="search-button">Search</button>
          </form>
          

          
          {searchResults.length === 0 ? (
  <p className="pharmacist-no-patient-placeholder"></p>
) : (
  <div className="scroll-container">
    <ul className="pharmacist-patient-list">
      {searchResults.map(p => (
        <li key={p.prescription_id}>
          <div className='nnn'>
            <div>
              <strong>ID:</strong> {p.prescription_id} — <strong>{p.patient.full_name}</strong>
            </div>
            <button
              className="details-button"
              onClick={() => setSelectedPrescription(p)}
              style={{ marginTop: '8px' }}
            >
              View
            </button>
          </div>
        </li>
      ))}
    </ul>
  </div>
)}
        </div>

        <div className="pharmacist-history-section">
          <div className="search-prescription-records">
      <h3>Filled Prescriptions</h3>

      <button className="search-icon-btn" onClick={() => openSearch("prescriptions")}>🔍</button>
      </div>
        
        <div className="table-container">
          <div className="table-header">
            <table className="log-table">
              
              <thead>
                <tr>
                  <th>Prescription ID</th>
                  <th>Notes</th>
                  <th>Filled At</th>
                  <th>Details</th>
                </tr>
              </thead>
            </table>
          </div>

          <div className="table-body-scroll">
            <table className="log-table">
              <tbody>
                {pharmacyLogs.map(log => (
                  <tr key={log.id}>
                    <td>{log.prescription}</td>
                    <td>{log.notes}</td>
                    <td>{new Date(log.created_at).toLocaleString()}</td>
                    <td>  
                      <button
                          className='details-button'
                          onClick={() => handleShowDetailsFromLog(log.prescription)}
                        >
                          Show Details
                        </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
        </div>
      </div>

      {selectedPrescription && (
        <div className="pharmacist-modal-overlay">
          <div className="pharmacist-modal-content">
            <div className="pharmacist-modal-header">
              <h2>Prescription #{selectedPrescription.prescription_id}</h2>
              <button className="close-btn" onClick={() => setSelectedPrescription(null)}>&times;</button>
            </div>

            <div className="pharmacist-section-box">
              <p><strong>👤 Patient:</strong> {selectedPrescription.patient.full_name} (ID: {selectedPrescription.patient.id})</p>
            </div>
            <div className="pharmacist-section-box">
              <p><strong>📋 Status:</strong> {selectedPrescription.status}</p>
            </div>
            <div className="pharmacist-section-box">
              <h4>💊 Medications</h4>
              <ul>
                {selectedPrescription.medications.map((m, i) => (
                  <li key={i}>
                    {m.name} — {m.dosage}, {m.frequency}, {m.duration}
                  </li>
                ))}
              </ul>
            </div>
            <div className="pharmacist-section-box">
              <h4>📝 Pharmacist Notes</h4>
              <textarea
                value={fillNote}
                onChange={(e) => setFillNote(e.target.value)}
                rows={3}
                placeholder="Optional notes..."
              />
            </div>

            <div style={{ textAlign: 'right' }}>
              <button className="cancel-btn" onClick={() => setSelectedPrescription(null)}>Cancel</button>
              {selectedPrescription.status === 'pending' && (
                <button className="fill-btn" onClick={() => fillPrescription(selectedPrescription.prescription_id)}>
                  Fill Prescription
                </button>
              )}
            </div>
          </div>
        </div>
      )}
      {logDetailData && (
        <div className="pharmacist-modal-overlay">
          <div className="pharmacist-modal-content">
            <div className="pharmacist-modal-header">
              <h2>Prescription #{logDetailData.prescription_id}</h2>
              <button className="close-btn" onClick={() => setLogDetailData(null)}>&times;</button>
            </div>

            <div className="pharmacist-section-box">
              <p><strong>👤 Patient:</strong> {logDetailData.patient.full_name} (ID: {logDetailData.patient.id})</p>
            </div>
            <div className="pharmacist-section-box">
              <p><strong>📋 Status:</strong> {logDetailData.status}</p>
              <p><strong>📅 Created:</strong> {logDetailData.created_date}</p>
              <p><strong>✅ Filled:</strong> {new Date(logDetailData.filled_date).toLocaleString()}</p>
            </div>
            <div className="pharmacist-section-box">
              <h4>💊 Medications</h4>
              <ul>
                {logDetailData.medications.map((m, i) => (
                  <li key={i}>
                    {m.name} — {m.dosage}, {m.frequency}, {m.duration}
                  </li>
                ))}
              </ul>
            </div>

            <div style={{ textAlign: 'right' }}>
              <button className="cancel-btn" onClick={() => setLogDetailData(null)}>Close</button>
            </div>
          </div>
        </div>
      )}

      {showSearchModal && (
              <SearchModal
                type="pharmacistPrescriptions"
                data={pharmacyLogs}
                onClose={() => setShowSearchModal(false)}
              />
            )}
      <footer className="app-footer">
  <p>© 2025 MediTrack — Empowering Doctors, Patients, and Pharmacies.</p>
</footer>
    </div>
  );
}
