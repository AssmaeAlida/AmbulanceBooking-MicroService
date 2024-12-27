import React, { useEffect, useState } from "react";
import "./CRUD.css";
import PreviewIcon from '@mui/icons-material/Visibility';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import { Modal, Button, TextField } from '@mui/material';

const CRUDAmbulances = () => {
  const [ambulances, setAmbulances] = useState([]);
  const [open, setOpen] = useState(false);
  const [editMode, setEditMode] = useState(false);
  const [currentAmbulance, setCurrentAmbulance] = useState({ id: null, matricule: '', status: '' });
  const [newAmbulance, setNewAmbulance] = useState({ matricule: '', status: '' });

  useEffect(() => {
    const fetchAmbulances = async () => {
      try {
        const response = await fetch('http://localhost:8085/ambulances/all');
        if (!response.ok) throw new Error('Failed to fetch ambulances');
        const data = await response.json();
        setAmbulances(data); // Assurez-vous que 'data' est un tableau d'objets
      } catch (error) {
        console.error(error);
      }
    };
    fetchAmbulances();
  }, []);

  const handleOpen = () => {
    setEditMode(false);
    setNewAmbulance({ matricule: '', status: '' });
    setOpen(true);
  };

  const handleClose = () => setOpen(false);

  const handleChange = (e) => {
    const { name, value } = e.target;
    if (editMode) {
      setCurrentAmbulance({ ...currentAmbulance, [name]: value });
    } else {
      setNewAmbulance({ ...newAmbulance, [name]: value });
    }
  };

  const handleAddAmbulance = async () => {
    try {
      const response = await fetch('http://localhost:8085/ambulances/add', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newAmbulance),
      });
      if (!response.ok) throw new Error('Failed to add ambulance');
      const addedAmbulance = await response.json();
      setAmbulances([...ambulances, addedAmbulance]);
      handleClose();
    } catch (error) {
      console.error(error);
    }
  };

  const handleEditAmbulance = async (id) => {
    setEditMode(true);
    const ambulanceToEdit = ambulances.find((ambulance) => ambulance.id === id);
    setCurrentAmbulance(ambulanceToEdit);
    setOpen(true);
  };

  const handleUpdateAmbulance = async () => {
    try {
      const response = await fetch(`http://localhost:8085/ambulances/${currentAmbulance.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(currentAmbulance),
      });
      if (!response.ok) throw new Error('Failed to update ambulance');
      const updatedAmbulance = await response.json();
      setAmbulances(ambulances.map((ambulance) => (ambulance.id === updatedAmbulance.id ? updatedAmbulance : ambulance)));
      handleClose();
    } catch (error) {
      console.error(error);
    }
  };

  const handleDeleteAmbulance = async (id) => {
    try {
      await fetch(`http://localhost:8085/ambulances/${id}`, { method: 'DELETE' });
      setAmbulances(ambulances.filter(ambulance => ambulance.id !== id));
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <div className="crud-container">
      <h1 className="crud-title">All Ambulances</h1>
      <div className="crud-header">
        <button className="crud-button add" onClick={handleOpen}>Add</button>
      </div>
      <table className="crud-table">
        <thead>
          <tr>
            <th>Id</th>
            <th>Matricule</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {ambulances.map((ambulance) => (
            <tr key={ambulance.id}>
              <td>{ambulance.id}</td>
              <td>{ambulance.matricule}</td>
              <td>{ambulance.status}</td>
              <td>
                <EditIcon className="crud-icon" style={{ cursor: 'pointer', color: 'green' }} onClick={() => handleEditAmbulance(ambulance.id)} />
                <DeleteIcon className="crud-icon" style={{ cursor: 'pointer', color: 'red' }} onClick={() => handleDeleteAmbulance(ambulance.id)} />
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {/* Modal pour ajouter ou modifier une ambulance */}
      <Modal open={open} onClose={handleClose}>
        <div style={{ padding: '20px', background: 'white', margin: '100px auto', maxWidth: '400px' }}>
          <h2>{editMode ? 'Modifier une Ambulance' : 'Ajouter une Ambulance'}</h2>
          <TextField
            label="Matricule"
            name="matricule"
            value={editMode ? currentAmbulance.matricule : newAmbulance.matricule}
            onChange={handleChange}
            fullWidth
            margin="normal"
          />
          <TextField
            label="Statut"
            name="status"
            value={editMode ? currentAmbulance.status : newAmbulance.status}
            onChange={handleChange}
            fullWidth
            margin="normal"
          />
          <Button onClick={editMode ? handleUpdateAmbulance : handleAddAmbulance} color="primary">
            {editMode ? 'Mettre à jour' : 'Ajouter'}
          </Button>
          <Button onClick={handleClose} color="secondary">Annuler</Button>
        </div>
      </Modal>
    </div>
  );
};

export default CRUDAmbulances;