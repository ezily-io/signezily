import { env } from '../utils/env';

export const FROM_ADDRESS = env('NEXT_PRIVATE_SMTP_FROM_ADDRESS') || 'noreply@documenso.com';
export const FROM_NAME = env('NEXT_PRIVATE_SMTP_FROM_NAME') || 'Documenso';

export const DOCUMENSO_INTERNAL_EMAIL = {
  name: FROM_NAME,
  address: FROM_ADDRESS,
};

export const SERVICE_USER_EMAIL = 'support@ezily.io';

export const EMAIL_VERIFICATION_STATE = {
  NOT_FOUND: 'NOT_FOUND',
  VERIFIED: 'VERIFIED',
  EXPIRED: 'EXPIRED',
  ALREADY_VERIFIED: 'ALREADY_VERIFIED',
} as const;

export const SUPPORT_EMAIL = process.env.NEXT_PRIVATE_SUPPORT_EMAIL || 'support@ezily.io';
