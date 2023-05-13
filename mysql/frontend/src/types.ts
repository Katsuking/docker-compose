export interface User {
    id?: number;
    name: string;
    email: string;
    password: string;
  }

  export interface Item {
    id: number;
    name: string;
    description: string;
    user_id: number;
  }