import React, { useState } from "react";
import axios from "axios";
import { User } from "./types";

// fastapi
axios.defaults.baseURL = 'http://127.0.0.1:8000';

const AddUserForm = () => {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    const newUser: User = { name, email, password };

    try {
      const response = await axios.post("/users/", newUser);
      console.log("New user created:", response.data);
      // Reset the form fields
      setName("");
      setEmail("");
      setPassword("");

    } catch (error) {
      console.error("Error creating user:", error);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
    <h2> 🔻ユーザー追加 </h2>
      <label>
        Name:
        <input
          type="text"
          value={name}
          onChange={(event) => setName(event.target.value)}
        />
      </label>
      <br />
      <label>
        Email:
        <input
          type="email"
          value={email}
          onChange={(event) => setEmail(event.target.value)}
        />
      </label>
      <br />
      <br />
      <label>
        Password:
        <input
          type="password"
          value={password}
          onChange={(event) => setPassword(event.target.value)}
        />
      </label>
      <br />
      <button type="submit">Create User</button>
    </form>
  );
};

export default AddUserForm;