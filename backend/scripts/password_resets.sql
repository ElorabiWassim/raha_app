-- Create table used by /api/auth/password-reset/* endpoints
-- Run this in Supabase SQL editor.

-- Needed for gen_random_uuid()
create extension if not exists pgcrypto;

create table if not exists public.password_resets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  email text not null,
  token_hash text not null,
  expires_at timestamptz not null,
  used_at timestamptz null,
  created_at timestamptz not null default now()
);

create index if not exists password_resets_token_hash_idx
  on public.password_resets (token_hash);

create index if not exists password_resets_user_id_idx
  on public.password_resets (user_id);

-- Optional cleanup policy can be added later (cron/job) to delete expired rows.
