import bcrypt from 'bcryptjs';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const email = 'admin@example.com';
  const rawPassword = 'supersecure';
  const hashed = await bcrypt.hash(rawPassword, 10);

  await prisma.user.upsert({
    where: { email },
    update: {},
    create: {
      email,
      password: hashed
    }
  });

  console.log('Admin seeded');
}

main().finally(() => prisma.$disconnect());
