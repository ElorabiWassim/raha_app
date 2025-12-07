require('dotenv').config();
const jwt = require('jsonwebtoken');

const key = process.env.SUPABASE_SERVICE_KEY;
console.log("Checking SUPABASE_SERVICE_KEY...");

if (!key) {
    console.error("❌ SUPABASE_SERVICE_KEY is MISSING or empty.");
} else {
    console.log("✅ SUPABASE_SERVICE_KEY is set.");
    try {
        const decoded = jwt.decode(key);
        if (decoded && decoded.role) {
             console.log(`Key Role: ${decoded.role}`);
             if (decoded.role === 'service_role') {
                 console.log("✅ This is a SERVICE ROLE key (Bypasses RLS).");
             } else {
                 console.log("⚠️ This looks like an ANON key (Subject to RLS).");
             }
        } else {
             console.log("⚠️ Could not decode JWT role from key.");
        }
    } catch (e) {
        console.error("Error decoding key:", e.message);
    }
}
