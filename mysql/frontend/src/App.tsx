import React from 'react';
import './App.css';
import Api from './api';
import AddUserForm from './Adduser';

function App() {
  return (
    <div className="App">
      <Api></Api>
      <AddUserForm></AddUserForm>
    </div>
  );
}

export default App;