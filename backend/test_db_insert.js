require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_KEY;

console.log('Testing Supabase Connection...');
console.log('URL:', supabaseUrl);
console.log('Key (first 20 chars):', supabaseKey?.substring(0, 20) + '...');
console.log('');

const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});

async function testInsert() {
  try {
    const testEmail = 'test_' + Date.now() + '@example.com';
    
    console.log('Attempting to insert test user...');
    const { data, error } = await supabase
      .from('users')
      .insert([
        {
          email: testEmail,
          password_hash: 'test_hash_123',
          full_name: 'Test User',
          phone_number: '0000000000',
          role: 'homeowner',
          status: 'active',
        },
      ])
      .select()
      .single();

    if (error) {
      console.error('❌ INSERT FAILED:', error.message);
      console.error('Error details:', JSON.stringify(error, null, 2));
    } else {
      console.log('✅ INSERT SUCCESS!');
      console.log('User created:', data);
    }
  } catch (e) {
    console.error('❌ Exception:', e.message);
  }
}

testInsert();
