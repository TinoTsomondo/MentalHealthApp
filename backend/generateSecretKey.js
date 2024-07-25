const crypto = require('crypto');

// Generate a random 64-byte key and convert it to a hexadecimal string
const secret = crypto.randomBytes(64).toString('hex');

// Print the generated secret key to the console
console.log(secret);
