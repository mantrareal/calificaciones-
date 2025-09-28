-- Script para arreglar problemas de base de datos
-- Ejecutar paso a paso en Supabase SQL Editor

-- PASO 1: Verificar qué tablas existen
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- PASO 2: Si las tablas existen, verificar estructura de users
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'users' AND table_schema = 'public';

-- PASO 3: Ver cuántos usuarios hay
SELECT COUNT(*) as total_users FROM users;

-- PASO 4: Ver todos los usuarios
SELECT id, email, first_name, last_name, role FROM users;

-- PASO 5: Si no hay usuarios, insertarlos
INSERT INTO users (id, email, first_name, last_name, role) VALUES
('demo-liner-001', 'liner@demo.com', 'Juan', 'Pérez', 'liner'),
('demo-closer-001', 'closer@demo.com', 'María', 'García', 'closer'),
('demo-manager-001', 'manager@demo.com', 'Carlos', 'López', 'manager')
ON CONFLICT (email) DO NOTHING;

-- PASO 6: Verificar que se insertaron
SELECT id, email, first_name, last_name, role FROM users WHERE email IN ('liner@demo.com', 'closer@demo.com', 'manager@demo.com');