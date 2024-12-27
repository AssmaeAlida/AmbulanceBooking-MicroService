import React, { useEffect, useState } from "react";
import "./CRUD.css";
import PreviewIcon from '@mui/icons-material/Visibility';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import { Modal, Button, TextField } from '@mui/material';

const CRUDDrivers = () => {
  const [drivers, setDrivers] = useState([]);
  const [open, setOpen] = useState(false);
  const [newDriver, setNewDriver] = useState({ id: '', latitude: '', longitude: '', name: '', phone: '', status: '', ambulanceId: '', email: '' });

  useEffect(() => {
    fetchDrivers(); // Récupérer les conducteurs au démarrage
  }, []);

  const fetchDrivers = async () => {
    try {
      const response = await fetch('http://localhost:8085/drivers/all');
      if (!response.ok) {
        throw new Error('Failed to fetch drivers');
      }
      const data = await response.json();
      setDrivers(data); // Mettre à jour l'état avec les conducteurs récupérés
    } catch (error) {
      console.error(error);
    }
  };

  const handleOpen = (driver = null) => {
    if (driver) {
      setNewDriver(driver); // Pré-remplir avec les données du conducteur pour modification
    } else {
      setNewDriver({ id: '', latitude: '', longitude: '', name: '', phone: '', status: '', ambulanceId: '', email: '' }); // Réinitialiser pour ajout
    }
    setOpen(true);
  };
  
  const handleClose = () => setOpen(false);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setNewDriver({ ...newDriver, [name]: value });
  };

  const handleAddOrUpdateDriver = async () => {
    try {
      const method = newDriver.id ? 'PUT' : 'POST';
      const url = newDriver.id ? `http://localhost:8085/drivers/${newDriver.id}` : 'http://localhost:8085/drivers/add';

      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(newDriver),
      });

      if (!response.ok) {
        throw new Error('Failed to save driver');
      }

      const driverData = await response.json();
      if (method === 'POST') {
        setDrivers([...drivers, driverData]); // Ajouter le nouveau conducteur
      } else {
        setDrivers(drivers.map(driver => (driver.id === driverData.id ? driverData : driver))); // Mettre à jour le conducteur existant
      }

      setNewDriver({ id: '', latitude: '', longitude: '', name: '', phone: '', status: '', ambulanceId: '', email: '' }); // Réinitialiser le formulaire
      handleClose();
    } catch (error) {
      console.error(error);
    }
  };

  const handleEditDriver = (driver) => {
    handleOpen(driver); // Ouvrir le modal pour modifier
  };

  const handleDeleteDriver = async (id) => {
    try {
      await fetch(`http://localhost:8085/drivers/${id}`, { method: 'DELETE' });
      setDrivers(drivers.filter(driver => driver.id !== id)); // Mettre à jour la liste des conducteurs après suppression
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <div className="crud-container">
      <h1 className="crud-title">All Drivers</h1>
      <div className="crud-header">
        <button className="crud-button add" onClick={() => handleOpen()}>Add</button>
      </div>
      <table className="crud-table">
        <thead>
          <tr>
            <th>No.</th>
            <th>Latitude</th>
            <th>Longitude</th>
            <th>Name</th>
            <th>Phone Number</th>
            <th>Status</th>
            <th>Ambulance-Id</th>
            <th>Email</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {drivers.map((driver) => (
            <tr key={driver.id}>
              <td>{driver.id}</td>
              <td>{driver.latitude}</td>
              <td>{driver.longitude}</td>
              <td>{driver.name}</td>
              <td>{driver.phone}</td>
              <td>{driver.status}</td>
              <td>{driver.ambulanceId}</td>
              <td>{driver.email}</td>
              <td>
                <EditIcon className="crud-icon" style={{ cursor: 'pointer', color: 'green' }} onClick={() => handleEditDriver(driver)} />
                <DeleteIcon className="crud-icon" style={{ cursor: 'pointer', color: 'red' }} onClick={() => handleDeleteDriver(driver.id)} />
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {/* Modal pour ajouter ou modifier un conducteur */}
      <Modal open={open} onClose={handleClose}>
        <div style={{ padding: '20px', background: 'white', margin: '100px auto', maxWidth: '400px' }}>
          <h2>{newDriver.id ? 'Modifier un Conducteur' : 'Ajouter un Conducteur'}</h2>
          <TextField label="Latitude" name="latitude" value={newDriver.latitude} onChange={handleChange} fullWidth margin="normal" />
          <TextField label="Longitude" name="longitude" value={newDriver.longitude} onChange={handleChange} fullWidth margin="normal" />
          <TextField label="Nom" name="name" value={newDriver.name} onChange={handleChange} fullWidth margin="normal" />
          <TextField label="Numéro de téléphone" name="phone" value={newDriver.phone} onChange={handleChange} fullWidth margin="normal" />
          <TextField label="Statut" name="status" value={newDriver.status} onChange={handleChange} fullWidth margin="normal" />
          <TextField label="Ambulance-Id" name="ambulanceId" value={newDriver.ambulanceId} onChange={handleChange} fullWidth margin="normal" />
          <TextField label="Email" name="email" value={newDriver.email} onChange={handleChange} fullWidth margin="normal" />
          <Button onClick={handleAddOrUpdateDriver} color="primary">{newDriver.id ? 'Modifier' : 'Ajouter'}</Button>
          <Button onClick={handleClose} color="secondary">Annuler</Button>
        </div>
      </Modal>
    </div>
  );
};

export default CRUDDrivers;