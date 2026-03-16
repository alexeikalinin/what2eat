-- Migration 018: Add instructions_en column to recipes for bilingual support
-- Run in Supabase SQL Editor or via Management API

ALTER TABLE recipes ADD COLUMN IF NOT EXISTS instructions_en TEXT;
