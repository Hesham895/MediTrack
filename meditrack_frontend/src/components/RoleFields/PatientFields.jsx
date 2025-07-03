import React from "react";

export default function PatientFields({ extra, setExtra }) {
  const handleChange = (e) => {
    const { name, value } = e.target;
    setExtra((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  return (
    <>
      <input
        className="auth-input"
        type="text"
        name="blood_group"
        placeholder="Blood Group"
        value={extra.blood_group || ""}
        onChange={handleChange}
      />

      <input
        className="auth-input"
        type="text"
        name="allergies"
        placeholder="Allergies"
        value={extra.allergies || ""}
        onChange={handleChange}
      />

      <input
        className="auth-input"
        type="text"
        name="emergency_contact_name"
        placeholder="Emergency Contact Name"
        value={extra.emergency_contact_name || ""}
        onChange={handleChange}
      />

      <input
        className="auth-input"
        type="text"
        name="emergency_contact_number"
        placeholder="Emergency Contact Number"
        value={extra.emergency_contact_number || ""}
        onChange={handleChange}
      />
    </>
  );
}
