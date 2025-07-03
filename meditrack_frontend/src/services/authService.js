import apiClient from './apiClient';

export const AuthService = {

    login : async (email, password) => {
    try {
      const response = await apiClient.post(
        `/auth/token/`, {
        email,
        password
        });
      
      return response;

    } catch (error) {
      console.error('Login failed:', error.response?.data || error.message);
      alert('Login failed: ' + (error.response?.data?.detail || error.message));
    }
  },

  register : async (endpoint, payload) => {
    try {
      await apiClient.post(
        endpoint, 
        payload
      );
      alert("Registration successful");

    } catch (error) {
      console.error(error.response?.data || error.message);
      alert(JSON.stringify(error.response?.data || "Registration failed", null, 2));
    }
  },

   getProfile: async () => {
    try {
      const response = await apiClient.get(`/auth/profile/`);      
      return response;

    } catch (error) {
      console.error('Error fetching data:', error);
      throw error;
    }
  },

  

};