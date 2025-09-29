-- Limpiar datos existentes
DELETE FROM follow_ups;
DELETE FROM ratings;
DELETE FROM users;

-- Crear tabla de empleados disponibles
CREATE TABLE IF NOT EXISTS available_employees (
  id TEXT PRIMARY KEY,
  employee_number TEXT UNIQUE NOT NULL,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('closer', 'liner', 'ftb', 'ftm', 'ftm_ftb', 'manager')),
  language TEXT NOT NULL,
  is_taken BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Recrear tabla users
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT,
  employee_id TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  FOREIGN KEY (employee_id) REFERENCES available_employees(id)
);

-- Habilitar seguridad
ALTER TABLE available_employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Crear politicas de acceso
CREATE POLICY "Allow public access available_employees" ON available_employees FOR ALL USING (true);
CREATE POLICY "Allow public access users" ON users FOR ALL USING (true);

-- Crear indices
CREATE INDEX idx_available_employees_number ON available_employees(employee_number);
CREATE INDEX idx_available_employees_role ON available_employees(role);
CREATE INDEX idx_available_employees_taken ON available_employees(is_taken);
CREATE INDEX idx_users_employee ON users(employee_id);

-- Insertar closers disponibles
INSERT INTO available_employees (id, employee_number, first_name, last_name, role, language) VALUES
('avail_40196', '40196', 'ALEJANDRO', 'ORTIZ BENITEZ', 'closer', 'ESP'),
('avail_23314', '23314', 'ALEXANDER MARC IAN', 'BUESS', 'closer', 'BILL'),
('avail_14520', '14520', 'ALI FAWED', 'SABAG MIRAFUENTES', 'closer', 'BILL'),
('avail_68230', '68230', 'ALMA MONICA', 'AGUILAR MEDINA', 'closer', 'ESP'),
('avail_9959', '9959', 'ANDRES ALEJANDRO ANTONIO', 'MARRON ALDANA', 'closer', 'ESP'),
('avail_44034', '44034', 'ARBEY AHMED JESUS', 'ACEVEDO DIAZ', 'closer', 'BILL'),
('avail_65868', '65868', 'BRUNO MAURICIO', 'PORTILLO ARRIOJA', 'closer', 'BILL'),
('avail_68879', '68879', 'CARLOS ISRAEL', 'FLORES SANCHEZ', 'closer', 'BILL'),
('avail_65779', '65779', 'DANIEL DANIEL MACDILLON', 'GALLOP BECERRA', 'closer', 'BILL'),
('avail_11113', '11113', 'DANIEL VILLELA', 'PEDRAS DE MEDEIROS', 'closer', 'TRILINGUE'),
('avail_45713', '45713', 'DEIKSON WESLEY', 'BARBOSA SOARES', 'closer', 'ESP'),
('avail_42491', '42491', 'DIANA KARLA', 'OVANDO VALERIANO', 'closer', 'BILL'),
('avail_38856', '38856', 'EDUARDO', 'ANAYA PORTILLO', 'closer', 'BILL'),
('avail_25631', '25631', 'EDUARDO', 'REYES CRUZ', 'closer', 'ESP'),
('avail_17292', '17292', 'EMANUELA LUISA', 'GARRO', 'closer', 'BILL'),
('avail_68637', '68637', 'FAUSTO', 'SANTOS LOPEZ', 'closer', 'BILL'),
('avail_68717', '68717', 'FRANCISCO GABRIEL', 'ESPINOSA DE LOS MONTEROS RUIZ', 'closer', 'BILL'),
('avail_65699', '65699', 'GABRIEL', 'GONZALEZ SANCHEZ', 'closer', 'BILL'),
('avail_9506', '9506', 'GLORIA ALEXANDRA', 'BROWN', 'closer', 'BILL'),
('avail_64389', '64389', 'GUADALUPE CAROLINA', 'DUQUE MORALES', 'closer', 'BILL'),
('avail_32647', '32647', 'GUSTAVO', 'OROZCO VAZQUEZ', 'closer', 'ESP'),
('avail_38708', '38708', 'IRVING', 'PONCE RODRIGUEZ', 'closer', 'BILL'),
('avail_47029', '47029', 'IVANNA AZENETT', 'ANDRADE RUIZ', 'closer', 'BILL'),
('avail_26868', '26868', 'JEAN PAUL', 'LOISSELL LAZARO', 'closer', 'BILL'),
('avail_38699', '38699', 'JESSICA GUADALUPE', 'DIAZ MORENO', 'closer', 'BILL'),
('avail_9445', '9445', 'JOSE ALFREDO', 'JAIMES SERRATO', 'closer', 'BILL'),
('avail_26807', '26807', 'JOSE JESUS', 'SERVIN MONTESINOS', 'closer', 'BILL'),
('avail_10152', '10152', 'JUAN CARLOS', 'ORTEGA PEREZ', 'closer', 'BILL'),
('avail_37813', '37813', 'KAREN PAMELA', 'RODRIGUEZ PEREZ', 'closer', 'ESP'),
('avail_24509', '24509', 'KARLA BELEN', 'CORIA BECERRA', 'closer', 'ESP'),
('avail_68454', '68454', 'LUIS JAIME', 'GONZALEZ LECHON', 'closer', 'BILL'),
('avail_26590', '26590', 'LUIS MANUEL', 'VARGAZ GAMBOA', 'closer', 'BILL'),
('avail_68724', '68724', 'MANUEL HECTOR', 'MANZANO TORRES', 'closer', 'BILL'),
('avail_10540', '10540', 'MANUEL', 'PINEDA ROSAS', 'closer', 'BILL'),
('avail_17968', '17968', 'MARIA EUGENIA', 'MORENO MARTINEZ', 'closer', 'BILL'),
('avail_68989', '68989', 'MARIA JESUS', 'AMARO RODRIGUEZ', 'closer', 'BILL'),
('avail_37337', '37337', 'MARIA MARGARITA', 'MOLINA RONQUILLO', 'closer', 'BILL'),
('avail_41695', '41695', 'NARDETTE LEROY', 'ZOEGER', 'closer', 'ESP'),
('avail_51345', '51345', 'NESTOR DANIEL', 'PERDOMO CANELONES', 'closer', 'ESP/PORT'),
('avail_67313', '67313', 'OMAR', 'MORELOS BELTRAN', 'closer', 'ESP'),
('avail_38050', '38050', 'OSCAR EMILIO', 'MARTINEZ CONSTANTINO', 'closer', 'BILL'),
('avail_65757', '65757', 'PABLO GABRIEL', 'DIAZ MOYANO', 'closer', 'ESP'),
('avail_30665', '30665', 'PAUL', 'BAUTISTA TORRES', 'closer', 'ESP'),
('avail_65077', '65077', 'RANDY JOSE', 'SANTIESTEBAN VALERO', 'closer', 'ESP'),
('avail_29983', '29983', 'REBECA', 'ESCAMILLA ASCENCIO', 'closer', 'BILL'),
('avail_32055', '32055', 'SEGUNDO', 'TORRES SOUMOULOU', 'closer', 'BILL'),
('avail_17967', '17967', 'SERGIO LUIS', 'GARCIA GORDILLO', 'closer', 'ESP'),
('avail_68668', '68668', 'VICTOR MANUEL', 'ACUNA DIAZ', 'closer', 'BILL'),
('avail_29598', '29598', 'VICTOR RAUL', 'SOTOMAYOR CASTILLO', 'closer', 'BILL'),
('avail_18019', '18019', 'VICTORIA ANGELICA', 'GONZALEZ CERVANTES', 'closer', 'BILL'),
('avail_68731', '68731', 'VIRGINIA MONSERRAT', 'LEZAMA RUIZ', 'closer', 'BILL'),
('avail_68225', '68225', 'WILLIAM', 'CEBALLOS MURRIETA', 'closer', 'BILL'),
('avail_47256', '47256', 'XIMENA', 'LEON MONTOYA', 'closer', 'ESP');

-- Insertar managers
INSERT INTO available_employees (id, employee_number, first_name, last_name, role, language) VALUES
('avail_admin_001', 'ADM001', 'GERENCIA', 'GENERAL', 'manager', 'BILL'),
('avail_admin_002', 'ADM002', 'SUPERVISOR', 'PRINCIPAL', 'manager', 'BILL');

-- Usuario de prueba
INSERT INTO users (id, email, employee_id) VALUES
('user_test_001', 'prueba@test.com', 'avail_40196');

UPDATE available_employees SET is_taken = true WHERE id = 'avail_40196';

-- Verificar creacion
SELECT 'CLOSERS DISPONIBLES' as tipo, COUNT(*) as cantidad FROM available_employees WHERE role = 'closer' AND is_taken = false
UNION ALL
SELECT 'CLOSERS REGISTRADOS' as tipo, COUNT(*) as cantidad FROM available_employees WHERE role = 'closer' AND is_taken = true
UNION ALL  
SELECT 'TOTAL CLOSERS' as tipo, COUNT(*) as cantidad FROM available_employees WHERE role = 'closer';