/* eslint-disable no-console */
require('dotenv').config();
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const supabase = require('../config/supabase');

const EMAIL = process.argv[2];

if (!EMAIL) {
  console.error('Usage: node scripts/seed_homeowner.js <email>');
  process.exit(1);
}

const nowIso = () => new Date().toISOString();

async function main() {
  console.log(`Seeding homeowner for: ${EMAIL}`);

  const { data: existingUsers, error: fetchError } = await supabase
    .from('users')
    .select('*')
    .eq('email', EMAIL);

  if (fetchError) {
    console.error('Failed to query users table:', fetchError);
    process.exit(1);
  }

  let user = existingUsers && existingUsers.length > 0 ? existingUsers[0] : null;

  if (user) {
    console.log(`User already exists: user_id=${user.user_id}, role=${user.role}`);
    if (user.role !== 'homeowner') {
      console.log('Updating role to homeowner (was different)');
      const { data: updated, error: updateError } = await supabase
        .from('users')
        .update({ role: 'homeowner', updated_at: nowIso() })
        .eq('user_id', user.user_id)
        .select()
        .single();

      if (updateError) {
        console.error('Failed to update user role:', updateError);
        process.exit(1);
      }
      user = updated;
    }
  } else {
    const randomPassword = crypto.randomBytes(32).toString('hex');
    const hashedPassword = await bcrypt.hash(randomPassword, 10);

    const fullName = EMAIL.split('@')[0];

    const { data: created, error: insertError } = await supabase
      .from('users')
      .insert({
        full_name: fullName,
        email: EMAIL,
        phone_number: null,
        password: hashedPassword,
        role: 'homeowner',
        created_at: nowIso(),
        updated_at: nowIso(),
      })
      .select()
      .single();

    if (insertError) {
      console.error('Failed to insert user:', insertError);
      process.exit(1);
    }

    user = created;
    console.log(`Created user: user_id=${user.user_id}`);
  }

  // Ensure homeowner profile exists
  const { data: existingHo, error: hoFetchError } = await supabase
    .from('homeowners')
    .select('homeowner_id')
    .eq('homeowner_id', user.user_id)
    .maybeSingle();

  if (hoFetchError) {
    console.error('Failed to query homeowners table:', hoFetchError);
    process.exit(1);
  }

  if (!existingHo) {
    const { error: hoInsertError } = await supabase.from('homeowners').insert({
      homeowner_id: user.user_id,
      home_address: null,
    });

    if (hoInsertError) {
      console.error('Failed to insert homeowner profile:', hoInsertError);
      process.exit(1);
    }

    console.log('Created homeowner profile');
  } else {
    console.log('Homeowner profile already exists');
  }

  console.log('Done. You can now use Google login for this email.');
}

main().catch((err) => {
  console.error('Seed failed:', err);
  process.exit(1);
});
