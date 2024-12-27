import React, { useEffect, useState } from 'react';
import './CRUD.css';

const PatientsList = () => {
  const [patients, setPatients] = useState([]); // État pour stocker les patients
  const [loading, setLoading] = useState(true); // État pour gérer le chargement
  const [error, setError] = useState(null); // État pour gérer les erreurs

  // Fonction pour récupérer les patients depuis l'API
  const fetchPatients = async () => {
    try {
      const response = await fetch('http://localhost:8083/patients/');
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      setPatients(data); // Stocke les patients dans l'état
      setLoading(false); // Fin du chargement
    } catch (err) {
      setError(err.message); // Stocke l'erreur dans l'état
      setLoading(false);
    }
  };

  // Appel de l'API lorsque le composant est monté
  useEffect(() => {
    fetchPatients();
  }, []);

  // Affichage pendant le chargement
  if (loading) {
    return <div>Loading...</div>;
  }

  // Affichage en cas d'erreur
  if (error) {
    return <div>Error: {error}</div>;
  }

  return (
    <div className="crud-container">
      <h1>All Patients</h1>
      <table className="crud-table">
        <thead>
          <tr>
            <th>#</th>
            <th>Last Name</th>
            <th>First Name</th>
            <th>Email</th>
            <th>Phone Number</th>
            <th>Latitude</th>
            <th>Longitude</th>
          </tr>
        </thead>
        <tbody>
          {patients.map((patient, index) => (
            <tr key={patient.id}>
              <td>{index + 1}</td>
              <td>{patient.lastName}</td>
              <td>{patient.firstName}</td>
              <td>{patient.email}</td>
              <td>{patient.phoneNumber}</td>
              <td>{patient.latitude}</td>
              <td>{patient.longitude}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default PatientsList;