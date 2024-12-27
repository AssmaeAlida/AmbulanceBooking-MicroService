import React from 'react';
import { Link } from 'react-router-dom';
import DashboardIcon from '@mui/icons-material/Dashboard';
import PersonIcon from '@mui/icons-material/Person';
import LocalHospitalIcon from '@mui/icons-material/LocalHospital';
import CommuteIcon from '@mui/icons-material/Commute';
import EventNoteIcon from '@mui/icons-material/EventNote';
import './Sidebar.css';

const Sidebar = () => {
  return (
    <div className="sidebar">
      <h2>Admin Panel</h2>
      <nav>
      <ul>
      <li>
        <Link to="/dashboard">
          <DashboardIcon style={{ color: '#4CAF50' }} /> Dashboard
        </Link>
      </li>
      <li>
        <Link to="/drivers">
          <PersonIcon style={{ color: '#2196F3' }} /> Drivers
        </Link>
      </li>
      <li>
        <Link to="/ambulances">
          <LocalHospitalIcon style={{ color: '#FF5722' }} /> Ambulances
        </Link>
      </li>
      <li>
        <Link to="/patients">
          <CommuteIcon style={{ color: '#FFEB3B' }} /> Patients
        </Link>
      </li>
      <li>
        <Link to="/reservations">
          <EventNoteIcon style={{ color: '#9C27B0' }} /> Reservations
        </Link>
      </li>
    </ul>
      </nav>
    </div>
  );
};

export default Sidebar;
