import axios from "axios";
import { User, UserCreate, Item, ItemCreate } from "./types";

const API_URL = "http://localhost:8000";

// ユーザー作成
export const createUser = async (user: UserCreate): Promise<User> => {
  const response = await axios.post(`${API_URL}/users/`, user);
  return response.data;
};

// ユーザー一覧取得
export const getUsers = async (): Promise<User[]> => {
  const response = await axios.get(`${API_URL}/users/`);
  return response.data;
};

// ユーザー取得
export const getUser = async (userId: number): Promise<User> => {
  const response = await axios.get(`${API_URL}/users/${userId}`);
  return response.data;
};

// アイテム作成
export const createItemForUser = async (
  userId: number,
  item: ItemCreate
): Promise<Item> => {
  const response = await axios.post(
    `${API_URL}/users/${userId}/items/`,
    item
  );
  return response.data;
};

// アイテム一覧取得
export const getItems = async (): Promise<Item[]> => {
  const response = await axios.get(`${API_URL}/items/`);
  return response.data;
};