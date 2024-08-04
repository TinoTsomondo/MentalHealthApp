const bcrypt = require('bcrypt');
const saltRounds = 10;

// List of new users and their passwords
const users = [
  { name: 'Tafadzwa Moyo', email: 'tafadzwa.moyo@example.com', password: 'Tafadzwa2024!' },
  { name: 'Chipo Ndlovu', email: 'chipo.ndlovu@example.com', password: 'Chipo@2024' },
  { name: 'Emma Brown', email: 'emma.brown@example.com', password: 'Emma2024!' },
  { name: 'Lindiwe Dube', email: 'lindiwe.dube@example.com', password: 'Lindiwe123' },
  { name: 'James Smith', email: 'james.smith@example.com', password: 'James@2024' },
  { name: 'Ropafadzo Mudzimu', email: 'ropafadzo.mudzimu@example.com', password: 'Ropa2024!' },
  { name: 'Mary Chirwa', email: 'mary.chirwa@example.com', password: 'Mary2024!' },
  { name: 'Tendai Masuku', email: 'tendai.masuku@example.com', password: 'Tendai@2024' },
  { name: 'John Doe', email: 'john.doe@example.com', password: 'John2024!' },
  { name: 'Sibusiso Nkosi', email: 'sibusiso.nkosi@example.com', password: 'Sibusiso@2024' },
  { name: 'Anna Johnson', email: 'anna.johnson@example.com', password: 'Anna2024!' },
  { name: 'Farai Muchena', email: 'farai.muchena@example.com', password: 'Farai123' },
  { name: 'Sipho Moyo', email: 'sipho.moyo@example.com', password: 'Sipho@2024' },
  { name: 'Grace Ndlovu', email: 'grace.ndlovu@example.com', password: 'Grace2024!' },
  { name: 'Bhekizizwe Ncube', email: 'bhekizizwe.ncube@example.com', password: 'Bheki2024!' },
  { name: 'Elizabeth Taylor', email: 'elizabeth.taylor@example.com', password: 'Elizabeth@2024' },
  { name: 'Dineo Ramabulana', email: 'dineo.ramabulana@example.com', password: 'Dineo123!' },
  { name: 'Farai Mudzimu', email: 'farai.mudzimu@example.com', password: 'Farai@2024' },
  { name: 'Thandeka Ndlovu', email: 'thandeka.ndlovu@example.com', password: 'Thandeka2024!' },
  { name: 'Peter Chikosi', email: 'peter.chikosi@example.com', password: 'Peter@2024' },
  { name: 'Abigail Chirwa', email: 'abigail.chirwa@example.com', password: 'Abigail2024!' }
];

// Function to hash passwords for the list of users
const hashUserPasswords = async () => {
  for (const user of users) {
    const hashedPassword = await bcrypt.hash(user.password, saltRounds);
    console.log(`Name: ${user.name}, Email: ${user.email}, Password: ${user.password}, Hashed: ${hashedPassword}`);
  }
};

// Run the hashing function
const runHashing = async () => {
  console.log('Hashing User Passwords:');
  await hashUserPasswords();
};

// Execute the hashing function
runHashing();
