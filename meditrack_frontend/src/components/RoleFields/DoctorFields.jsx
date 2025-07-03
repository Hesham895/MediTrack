import React from "react";

export default function DoctorFields({ extra, setExtra }) {
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
        name="license_number"
        placeholder="License Number"
        value={extra.license_number || ""}
        onChange={handleChange}
        required
      />

      <input
        className="auth-input"
        type="text"
        name="specialization"
        placeholder="Specialization"
        value={extra.specialization || ""}
        onChange={handleChange}
        required
      />

      <input
        className="auth-input"
        type="text"
        name="hospital_name"
        placeholder="Hospital Name"
        value={extra.hospital_name || ""}
        onChange={handleChange}
      />
    </>
  );
}