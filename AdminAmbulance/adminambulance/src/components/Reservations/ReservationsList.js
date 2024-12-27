import React, { useEffect, useState } from 'react';
import './CRUD.css';

const ReservationsList = () => {
    const [reservations, setReservations] = useState([]); 
    const [loading, setLoading] = useState(true); 
    const [error, setError] = useState(null);

    const fetchReservations = async () => {
      try {
        const response = await fetch('http://localhost:8086/reservations/');
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        setReservations(data); // Stocke les patients dans l'état
        setLoading(false); // Fin du chargement
      } catch (err) {
        setError(err.message); // Stocke l'erreur dans l'état
        setLoading(false);
      }
    };
      useEffect(() => {
        fetchReservations();
      }, []);

      if (loading) {
        return <div>Loading...</div>;
      }

      if (error) {
        return <div>Error: {error}</div>;
      }

  return (
    <div className="crud-container">
      <h1>List of Reservations</h1>
      <table className="crud-table">
        <thead>
          <tr>
            <th>#</th>
            <th>Ambulance-Id</th>
            <th>Patient-Id</th>
            <th>Reservation Time</th>
            <th>Status</th>

          </tr>
        </thead>
        <tbody>
          {reservations.map((reservation,index) =>(

          <tr key={reservation.id}>
            <td>{index + 1}</td>
            <td>{reservation.ambulance_id}</td>
            <td>{reservation.patient_id}</td>
            <td>{reservation.reservation_time}</td>
            <td>{reservation.status}</td>
          </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ReservationsList;
