import apiClient from './apiClient';

export const DoctorService = {


    
   getDoctor: async () => {
    try {
      const response = await apiClient.get(`/auth/doctors/me/`);      
      return response;

    } catch (error) {
      console.error('Error fetching doctor data:', error);
      throw error;
    }
  },

  createMedicalRecord : async (data) => {
    try {
      const response = await apiClient.post(
        `/medical/medical-records/`,
        data 
      );
      alert("Medical record created successfully.");
      return response;

    } catch (error) {
      console.error("Medical record creation failed:", error.response?.data || error.message);
      alert("Error: " + JSON.stringify(error.response?.data || error.message));
    }
  },

  createPrescription  : async (data) => {
    try {
      const response = await apiClient.post(
        `/medical/prescriptions/`,
        data 
      );
      alert("Prescription added successfully.");
      return response;

    } catch (error) {
      console.error("Prescription error:", error.response?.data || error.message);
      alert("Failed to add prescription: " + JSON.stringify(error.response?.data || error.message));
    }
  },

  searchPatient: async (search) => {
    try {
      const response = await apiClient.get(
        `/auth/patients/?search=${search}`
      );
      return response;
      
    } catch (error) {
      console.error('Error searching patients:', error);
      alert(error);
      throw error;
    }
  },

  getMedicalRecord : async () => {
    try {
      const response = await apiClient.get(`/medical/medical-records/`);
      return response;

    } catch (error) {
      console.error('Error fetching doctor data or records:', error);
      throw error;
    }
  },

};