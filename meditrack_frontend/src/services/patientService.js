import apiClient from './apiClient';

export const patientService = {
  getDashboard: async () => {
    try {
      const response = await apiClient.get(`/patients/dashboard/`);
      return response.data;
    } catch (err) {
      console.error("Error fetching dashboard:", err);
      alert("Failed to load patient dashboard.");
      throw err;
    }
  },

  getMedicalRecords: async (patientId) => {
    try {
      const response = await apiClient.get(`/medical/medical-records/?patient=${patientId}`);
      return response;
    } catch (err) {
      console.error("Error fetching medical records:", err);
      alert("Failed to load medical records.");
      throw err;
    }
  },

  getPrescriptions: async () => {
    try {
      const response = await apiClient.get(`/patients/prescriptions/`);
      return response;
    } catch (err) {
      console.error("Error fetching prescriptions:", err);
      alert("Failed to load prescriptions.");
      throw err;
    }
  }
};
