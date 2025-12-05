const request = require('supertest');
const app = require('../server');

async function run() {
  console.log('Running backend endpoint smoke tests...');

  const loginResponse = await request(app)
    .post('/api/auth/login')
    .send({ email: 'test@example.com', password: 'secret' })
    .set('Accept', 'application/json');

  console.log('\nPOST /api/auth/login');
  console.log('Status:', loginResponse.status);
  console.log('Body:', loginResponse.body);

  const profileResponse = await request(app)
    .get('/api/profile')
    .set('Accept', 'application/json');

  console.log('\nGET /api/profile (no token)');
  console.log('Status:', profileResponse.status);
  console.log('Body:', profileResponse.body);
}

run()
  .then(() => {
    console.log('\nSmoke tests finished.');
    process.exit(0);
  })
  .catch((err) => {
    console.error('Smoke tests failed with error:', err);
    process.exit(1);
  });
