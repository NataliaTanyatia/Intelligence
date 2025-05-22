\use client'; >> "app/page.tsx"
echo  >> "app/page.tsx"
echo import { signOut, useSession } from \next-auth/react';

export default function Home() {
  const { data: session } = useSession();

  return (
    <div className="p-4 space-y-4">
      <h1 className="text-2xl font-bold">Welcome to Intelligence</h1>

      {session ? (
        <div>
          <p className="mb-2">Signed in as: {session.user?.email}</p>
          <button
            className="bg-red-600 text-white px-4 py-2 rounded"
            onClick={() => signOut()}
          >
            Sign Out
          </button>
        </div>
      ) : (
        <p>You are not signed in. Go to /auth/signin</p>
      )}
    </div>
  );
}
