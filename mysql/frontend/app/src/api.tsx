import React, { useState, useEffect } from "react";
import axios from "axios";
import { User, Item } from "./types";

const Api = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [items, setItems] = useState<Item[]>([]);

  useEffect(() => {
    const getUsers = async () => {
      const response = await axios.get("/users/");
      setUsers(response.data);
    };

    getUsers();
  }, []);

  useEffect(() => {
    const getItems = async () => {
      const response = await axios.get("/items/");
      setItems(response.data);
    };

    getItems();
  }, []);

  return (
    <div>
      <h1>Users:</h1>
      <ul>
        {users.map((user) => (
          <li key={user.id}>{user.name}</li>
        ))}
      </ul>

      <h1>Items:</h1>
      <ul>
        {items.map((item) => (
          <li key={item.id}>{item.name}</li>
        ))}
      </ul>
    </div>
  );
};

export default Api;