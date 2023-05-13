import React, { useState, useEffect } from "react";
import axios from "axios";
import { User, Item } from "./types";

axios.defaults.baseURL = 'http://127.0.0.1:8000';

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

  console.log(users);

  return (
    <div>
      <h1>ユーザー 一覧</h1>
      <ul>
        {users.map((user) => (
          <li key={user.id}>ユーザー名:{user.name} メールアドレス:{user.email}</li>
        ))}
      </ul>

      <h1>アイテム 一覧</h1>
      <ul>
        {items.map((item) => (
          <li key={item.id}>{item.name}</li>
        ))}
      </ul>
    </div>
  );
};

export default Api;
