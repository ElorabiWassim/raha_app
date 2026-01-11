const nodemailer = require('nodemailer');

const isEmailConfigured = () => {
  return (
    !!process.env.SMTP_HOST &&
    !!process.env.SMTP_PORT &&
    !!process.env.SMTP_USER &&
    !!process.env.SMTP_PASS &&
    !!process.env.SMTP_FROM
  );
};

const getTransporter = () => {
  if (!isEmailConfigured()) return null;

  return nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: Number(process.env.SMTP_PORT),
    secure: String(process.env.SMTP_SECURE || '').toLowerCase() === 'true',
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASS,
    },
  });
};

const sendPasswordResetEmail = async ({ to, token, expiresMinutes }) => {
  const transporter = getTransporter();
  if (!transporter) {
    return { ok: false, error: 'SMTP is not configured' };
  }

  const appName = process.env.APP_NAME || 'Ra7a';

  // Optional: you can provide a deep link or web URL that opens your reset screen.
  // If you set APP_RESET_URL, we will include it with token as query param.
  const resetBaseUrl = process.env.APP_RESET_URL;
  const resetUrl = resetBaseUrl
    ? `${resetBaseUrl}${resetBaseUrl.includes('?') ? '&' : '?'}token=${encodeURIComponent(token)}`
    : null;

  const subject = `${appName} - Password reset`;

  const textLines = [
    `We received a request to reset your ${appName} password.`,
    '',
    `Your reset token (valid for ${expiresMinutes} minutes):`,
    token,
    '',
  ];

  if (resetUrl) {
    textLines.push('Reset link:');
    textLines.push(resetUrl);
    textLines.push('');
  }

  textLines.push('If you did not request this, you can ignore this email.');

  const text = textLines.join('\n');

  await transporter.sendMail({
    from: process.env.SMTP_FROM,
    to,
    subject,
    text,
  });

  return { ok: true };
};

module.exports = {
  isEmailConfigured,
  sendPasswordResetEmail,
};
