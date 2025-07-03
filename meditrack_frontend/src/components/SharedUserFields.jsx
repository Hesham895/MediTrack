import React from "react";

export default function SharedUserFields({ user, setUser }) {
  const handleChange = (e) => {
    const { name, value, files } = e.target;
    setUser((prev) => ({
      ...prev,
      [name]: files ? files[0] : value,
    }));
  };

  return (
    <>
      <input
        className="auth-input"
        type="email"
        name="email"
        placeholder="Email"
        value={user.email}
        onChange={handleChange}
        required
      />

      <input
        className="auth-input"
        type="text"
        name="first_name"
        placeholder="First Name"
        value={user.first_name}
        onChange={handleChange}
      />

      <input
        className="auth-input"
        type="text"
        name="last_name"
        placeholder="Last Name"
        value={user.last_name}
        onChange={handleChange}
      />

      <input
        className="auth-input"
        type="password"
        name="password"
        placeholder="Password"
        value={user.password}
        onChange={handleChange}
        required
      />

      <input
        className="auth-input"
        type="password"
        name="confirm_password"
        placeholder="Confirm Password"
        value={user.confirm_password}
        onChange={handleChange}
        required
      />

      <select
        className="auth-input"
        name="role"
        value={user.role}
        onChange={handleChange}
      >
        <option value="patient">Patient</option>
        <option value="doctor">Doctor</option>
        <option value="pharmacist">Pharmacist</option>
      </select>

      <input
        className="auth-input"
        type="text"
        name="phone_number"
        placeholder="Phone Number"
        value={user.phone_number}
        onChange={handleChange}
      />

      <input
        className="auth-input"
        type="date"
        name="date_of_birth"
        placeholder="Date of Birth"
        value={user.date_of_birth}
        onChange={handleChange}
      />

      <label style={{ fontSize: "0.9rem", marginTop: "0.5rem" }}>
        Profile Picture:
      </label>
      <input
        className="auth-input"
        type="file"
        name="profile_picture"
        accept="image/*"
        onChange={handleChange}
      />
    </>
  );
}
