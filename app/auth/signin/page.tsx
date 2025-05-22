\use client'; >> "app/auth/signin/page.tsx"
echo  >> "app/auth/signin/page.tsx"
echo import { signIn } from \next-auth/react';
import { useState } from 'react';

export default function SignInPage() {
  const [email, setEmail] = useState(\' );
  const [password, setPassword] = useState(\' );

  return (
    <div className="p-4 space-y-4 max-w-md mx-auto">
      <h1 className="text-2xl font-bold">Sign In</h1>
      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        className="w-full border p-2 rounded"
      />
      <input
        type="password"
        placeholder="Password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        className="w-full border p-2 rounded"
      />
      <button
        onClick={() => signIn('credentials', { email, password })}
        className="bg-blue-600 text-white px-4 py-2 rounded"
      >
        Sign In
      </button>
    </div>
  );
}
