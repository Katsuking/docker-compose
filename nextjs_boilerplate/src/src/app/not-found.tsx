// rafce

import Link from "next/link";

// 404 page not found 用
const NotFoundPage = () => {
  return (
    <>
      <h1> page not found</h1>
      <Link href={"/portfolio"}>go back to products page</Link>
    </>
  );
};

export default NotFoundPage;
