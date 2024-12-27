import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Sidebar from './components/Sidebar/Sidebar';
import Header from './components/Header/Header';
import DashboardAdmin from './components/Dashboard/DashboardAdmin';
import CRUDDrivers from './components/CRUDDrivers/CRUDDrivers';
import CRUDAmbulances from './components/CRUDAmbulances/CRUDAmbulances';
import PatientsList from './components/Patients/PatientsList';
import ReservationsList from './components/Reservations/ReservationsList';
import './styles/main.css';

function App() {
  return (
    <Router>
      <div className="app">
        <Sidebar />
        <div className="main-content">
          <Header />
          <div className="content">
            <Routes>
              <Route path="/dashboard" element={<DashboardAdmin />} />
              <Route path="/drivers" element={<CRUDDrivers />} />
              <Route path="/ambulances" element={<CRUDAmbulances />} />
              <Route path="/patients" element={<PatientsList />} />
              <Route path="/reservations" element={<ReservationsList />} />
            </Routes>
          </div>
        </div>
      </div>
    </Router>
  );
}

export default App;
