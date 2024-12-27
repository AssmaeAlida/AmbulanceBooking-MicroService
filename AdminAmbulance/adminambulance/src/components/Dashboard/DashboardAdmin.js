import React, { useEffect, useState } from 'react';
import { Line } from 'react-chartjs-2';
import { Bar } from 'react-chartjs-2';
import { Doughnut } from 'react-chartjs-2';
import { MapContainer, TileLayer, Marker } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import './DashboardAdmin.css';
import { Chart, registerables } from 'chart.js';
import DriveEtaIcon from '@mui/icons-material/DriveEta';
import LocalHospitalIcon from '@mui/icons-material/LocalHospital';
import EventNoteIcon from '@mui/icons-material/EventNote';
import PersonIcon from '@mui/icons-material/Person';

// Enregistrer tous les éléments de Chart.js
Chart.register(...registerables);

const DashboardAdmin = () => {
    const [driverCount, setDriverCount] = useState(0);
    const [ambulanceCount, setAmbulanceCount] = useState(0);
    const [reservationCount, setReservationCount] = useState(0);
    const [patientCount, setPatientCount] = useState(0);

    const lineChartData = {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
        datasets: [{
            label: 'Reservation',
            data: [30, 20, 50, 40, 70, 60, 80],
            fill: false,
            borderColor: 'rgba(75,192,192,1)',
            tension: 0.1
        }]
    };

    const barChartData = {
        labels: ['2019', '2020', '2021', '2022'],
        datasets: [{
            label: 'Revenus',
            data: [100, 200, 300, 400],
            backgroundColor: ['rgba(255,99,132,0.2)', 'rgba(54,162,235,0.2)', 'rgba(255,206,86,0.2)', 'rgba(75,192,192,0.2)'],
            borderColor: ['rgba(255,99,132,1)', 'rgba(54,162,235,1)', 'rgba(255,206,86,1)', 'rgba(75,192,192,1)'],
            borderWidth: 1
        }]
    };

    const doughnutChartData = {
        labels: ['A', 'B', 'C', 'D'],
        datasets: [{
            data: [35, 20, 15, 30],
            backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
        }]
    };

    useEffect(() => {
        const fetchDashboardData = async () => {
            try {
                const [driversResponse, ambulancesResponse, reservationsResponse, patientsResponse] = await Promise.all([
                    fetch('http://localhost:8085/drivers/all'),
                    fetch('http://localhost:8085/ambulances/all'),
                    fetch('http://localhost:8086/reservations/'),
                    fetch('http://localhost:8083/patients/')
                ]);

                if (!driversResponse.ok || !ambulancesResponse.ok || !reservationsResponse.ok || !patientsResponse.ok) {
                    throw new Error('Failed to fetch data');
                }

                const driversData = await driversResponse.json();
                const ambulancesData = await ambulancesResponse.json();
                const reservationsData = await reservationsResponse.json();
                const patientsData = await patientsResponse.json();

                setDriverCount(driversData.length); // Assurez-vous que driversData retourne un tableau
                setAmbulanceCount(ambulancesData.length); // Idem pour ambulancesData
                setReservationCount(reservationsData.length); // Idem pour reservationsData
                setPatientCount(patientsData.length); // Idem pour patientsData
            } catch (error) {
                console.error(error);
            }
        };

        fetchDashboardData();
    }, []);

    return (
        <div className="dashboard">
            <header>
                <h1>Tableau de bord</h1>
            </header>
            <div className="dashboard-header">
                <div className="icon">
                    
                    <DriveEtaIcon style={{ color: '#FF5722', fontSize: '84px' }} />
                    <span className="icon-number">{driverCount}</span><h2>Drivers</h2>
                </div>
                <div className="icon">
                    <LocalHospitalIcon style={{ color: '#2196F3', fontSize: '84px' }} />
                    <span className="icon-number">{ambulanceCount}</span><h2>Ambulances</h2>
                </div>
                <div className="icon">
                    <EventNoteIcon style={{ color: '#FFEB3B', fontSize: '84px' }} />
                    <span className="icon-number">{reservationCount}</span><h2>Reservations</h2>
                </div>
                <div className="icon">
                    <PersonIcon style={{ color: '#4CAF50', fontSize: '84px' }} />
                    <span className="icon-number">{patientCount}</span><h2>Patients</h2>
                </div>
            </div>
            <div className="charts">
                <div className="chart">
                    <h2>Reservations</h2>
                    <Line data={lineChartData} />
                </div>
                <div className="chart">
                    <h2>Revenus</h2>
                    <Bar data={barChartData} />
                </div>
                <div className="chart">
                    <h2>Répartition</h2>
                    <Doughnut data={doughnutChartData} />
                </div>
            </div>
            <div className="map">
                <h2>Carte</h2>
                <MapContainer center={[51.505, -0.09]} zoom={2} style={{ height: '300px', width: '100%' }}>
                    <TileLayer
                        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                    />
                    <Marker position={[51.505, -0.09]} />
                </MapContainer>
            </div>
        </div>
    );
};

export default DashboardAdmin;