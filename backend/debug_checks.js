require('dotenv').config();
const supabase = require('./config/supabase');

console.log('--- ENV CHECK ---');
console.log('PORT:', process.env.PORT);
console.log('SUPABASE_URL:', process.env.SUPABASE_URL ? 'Loaded' : 'MISSING');
console.log('SUPABASE_KEY:', process.env.SUPABASE_SERVICE_KEY ? 'Loaded' : 'MISSING');

console.log('\n--- SUPABASE CLIENT CHECK ---');
try {
    console.log('Supabase client initialized:', !!supabase);
    console.log('Supabase Auth defined:', !!supabase.auth);
} catch (e) {
    console.error('Supabase Client Error:', e.message);
}

console.log('\n--- CONTROLLER CHECK ---');
try {
    const authController = require('./controllers/auth.controller');
    console.log('Auth controller loaded:', Object.keys(authController));
} catch (e) {
    console.error('Auth Controller Load Error:', e.stack);
}
