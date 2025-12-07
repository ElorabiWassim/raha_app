require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');
const bcrypt = require('bcryptjs');

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_KEY;

const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});

async function testInsertWithPrimaryKey() {
  try {
    const { v4: uuidv4 } = require('crypto').randomUUID ? { v4: () => require('crypto').randomUUID() } : require('uuid');
    const userId = require('crypto').randomUUID();
    const testEmail = 'test_' + Date.now() + '@example.com';
    const passwordHash = await bcrypt.hash('test123', 10);
    
    console.log('Testing insert with explicit UUID...');
    console.log('Generated UUID:', userId);
    
    const { data, error } = await supabase
      .from('users')
      .insert([
        {
          user_id: userId,  // Explicitly providing UUID
          email: testEmail,
          password: passwordHash,
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
      console.error('Error code:', error.code);
      console.error('Error details:', JSON.stringify(error, null, 2));
    } else {
      console.log('✅ INSERT SUCCESS!');
      console.log('User created:', data);
    }
  } catch (e) {
    console.error('❌ Exception:', e.message);
  }
}

testInsertWithPrimaryKey();
