-- Club Vacacional Database Setup
-- Run this script in your Supabase SQL Editor

-- Drop existing tables if they exist
DROP TABLE IF EXISTS follow_ups CASCADE;
DROP TABLE IF EXISTS ratings CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Create users table
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'liner' CHECK (role IN ('liner', 'closer', 'manager')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create ratings table
CREATE TABLE ratings (
  id TEXT PRIMARY KEY,
  evaluator_id TEXT NOT NULL,
  evaluated_id TEXT NOT NULL,
  ratings_json JSONB NOT NULL,
  comments TEXT,
  date DATE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  FOREIGN KEY (evaluator_id) REFERENCES users(id),
  FOREIGN KEY (evaluated_id) REFERENCES users(id)
);

-- Create follow_ups table
CREATE TABLE follow_ups (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  data_json JSONB NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE follow_ups ENABLE ROW LEVEL SECURITY;

-- Create policies for public access (simple for MVP)
CREATE POLICY "Allow public access users" ON users FOR ALL USING (true);
CREATE POLICY "Allow public access ratings" ON ratings FOR ALL USING (true);
CREATE POLICY "Allow public access follow_ups" ON follow_ups FOR ALL USING (true);

-- Create indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_ratings_evaluator ON ratings(evaluator_id);
CREATE INDEX idx_ratings_evaluated ON ratings(evaluated_id);
CREATE INDEX idx_ratings_date ON ratings(date DESC);
CREATE INDEX idx_followups_user ON follow_ups(user_id);

-- Insert sample data
INSERT INTO users (id, email, first_name, last_name, role) VALUES
('liner-001-sample', 'liner1@test.com', 'Juan', 'Pérez', 'liner'),
('closer-001-sample', 'closer1@test.com', 'María', 'García', 'closer'),
('manager-001-sample', 'manager1@test.com', 'Carlos', 'López', 'manager'),
('liner-002-sample', 'liner2@test.com', 'Ana', 'Martínez', 'liner'),
('closer-002-sample', 'closer2@test.com', 'Roberto', 'Sánchez', 'closer');

-- Insert sample rating
INSERT INTO ratings (id, evaluator_id, evaluated_id, ratings_json, comments, date) VALUES
('rating-001-sample', 'liner-001-sample', 'closer-001-sample', '{"Saludo a prospectos": 5, "Apoyo en explicación pasado/presente/futuro": 4}', 'Excelente trabajo en general', CURRENT_DATE);