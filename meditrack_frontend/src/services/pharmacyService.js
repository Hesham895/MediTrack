import apiClient from './apiClient';


export const pharmacyService = {

  getDashboard: async () => {
    try {
      const response = await apiClient.get(`/pharmacy/dashboard/`);

      return response;

    } catch (error) {
      console.error('Error fetching dashboard data:', error);
      throw error;
    }
  },

  getPrescriptions: async (status = null, page = 1) => {
    try {
      let url = `/pharmacy/prescription-list/?page=${page}`;
      if (status) {
        url += `&status=${status}`;
      }
      const response = await apiClient.get(url);
      return response.data;
    } catch (error) {
      console.error('Error fetching prescriptions:', error);
      throw error;
    }
  },


  searchPatient: async (query) => {
    try {
      const response = await apiClient.get(
        `/pharmacy/prescription-list/search_patient/?q=${encodeURIComponent(query)}`
      );
      console.log(response.data);
      return response.data;
    } catch (error) {
      console.error('Error searching patients:', error);
      alert(error);
      throw error;
    }
  },


  getPrescription: async (id) => {
    try {
      const response = await apiClient.get(`/pharmacy/prescription-list/${id}/`);
      return response.data;
    } catch (error) {
      console.error(`Error fetching prescription ${id}:`, error);
      throw error;
    }
  },


  fillPrescription: async (prescriptionId, notes = '') => {
    try {
      const response = await apiClient.post(
        `/pharmacy/prescriptions/${prescriptionId}/fill_prescription/`,
        { notes }
      );
      return response.data;
    } catch (error) {
      console.error('Error filling prescription:', error);
      throw error;
    }
  },


  getPharmacyLogs: async () => {
    try {
      const response = await apiClient.get(`/pharmacy/logs/`);
      console.log("log",response.data );
      return response.data;
      
    } catch (error) {
      console.error('Error fetching pharmacy logs:', error);
      throw error;
    }
  }
};
