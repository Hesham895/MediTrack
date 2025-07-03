import React from "react";

export default function PharmacistFields({ extra, setExtra }) {
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
        name="pharmacy_name"
        placeholder="Pharmacy Name"
        value={extra.pharmacy_name || ""}
        onChange={handleChange}
        required
      />

      <input
        className="auth-input"
        type="text"
        name="pharmacy_address"
        placeholder="Pharmacy Address"
        value={extra.pharmacy_address || ""}
        onChange={handleChange}
        required
      />
    </>
  );
}
