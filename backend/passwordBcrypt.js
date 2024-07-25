const bcrypt = require('bcrypt');
const saltRounds = 10;

// List of users and their passwords
const users = [
  { name: 'Emily Chirwa', password: 'Emily2024!' },
  { name: 'James Moyo', password: 'James@2024' },
  { name: 'Patience Dube', password: 'Patience123' },
  { name: 'Oliver Ndlovu', password: 'Oliver@2024' },
  { name: 'Sarah Macheka', password: 'Sarah2024!' },
  { name: 'John Mutasa', password: 'John@2024' }
];

// List of therapists and their plain passwords
const therapists = [
  { fullName: 'Tariro Nyoni', email: 'tariro.nyoni@weheal.com', password: 'Tariro2024!' },
  { fullName: 'Tawanda Moyo', email: 'tawanda.moyo@weheal.com', password: 'Tawanda@2024' },
  { fullName: 'Chipo Ndlovu', email: 'chipo.ndlovu@weheal.com', password: 'Chipo123!' },
  { fullName: 'Simbarashe Mutsa', email: 'simbarashe.mutsa@weheal.com', password: 'Simba2024!' },
  { fullName: 'Ropafadzo Mudzimu', email: 'ropafadzo.mudzimu@weheal.com', password: 'Ropa2024!' },
  { fullName: 'Kudakwashe Chikosi', email: 'kudakwashe.chikosi@weheal.com', password: 'Kuda@2024' }
];

// Function to hash passwords for the list of users
const hashUserPasswords = async () => {
  for (const user of users) {
    const hashedPassword = await bcrypt.hash(user.password, saltRounds);
    console.log(`Name: ${user.name}, Password: ${user.password}, Hashed: ${hashedPassword}`);
  }
};

// Function to hash passwords for the list of therapists
const hashTherapistPasswords = async () => {
  for (const therapist of therapists) {
    const hashedPassword = await bcrypt.hash(therapist.password, saltRounds);
    console.log(`FullName: ${therapist.fullName}, Email: ${therapist.email}, Password: ${therapist.password}, Hashed: ${hashedPassword}`);
  }
};

// Function to hash individual passwords
const generateHash = async (password) => {
  const hash = await bcrypt.hash(password, saltRounds);
  console.log(`Password: ${password}, Hash: ${hash}`);
};

// Run the hashing functions
const runHashing = async () => {
  console.log('Hashing User Passwords:');
  await hashUserPasswords();
  
  console.log('\nHashing Therapist Passwords:');
  await hashTherapistPasswords();
  
  console.log('\nHashing Individual Passwords:');
  await generateHash('simbarashe');
  await generateHash('nokutenda');
};

// Execute the hashing functions
runHashing();
