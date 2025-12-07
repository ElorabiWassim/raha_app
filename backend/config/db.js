const { Pool } = require('pg');

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  console.warn('DATABASE_URL is not set. Postgres connection will fail until it is configured.');
}

const pool = new Pool({ connectionString });

module.exports = pool;
