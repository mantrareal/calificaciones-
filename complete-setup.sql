-- SCRIPT COMPLETO PARA SISTEMA PROFESIONAL CLUB VACACIONAL
-- Copiar TODO y ejecutar en Supabase SQL Editor

-- PASO 1: Actualizar estructura
ALTER TABLE users ADD COLUMN IF NOT EXISTS employee_number TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS language TEXT DEFAULT 'BILL';
ALTER TABLE ratings ADD COLUMN IF NOT EXISTS is_anonymous BOOLEAN DEFAULT true;

-- PASO 2: Limpiar datos de prueba
DELETE FROM follow_ups;
DELETE FROM ratings; 
DELETE FROM users;

-- PASO 3: Crear usuarios gerenciales
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('manager_001', 'gerencia@club.com', 'GERENCIA', 'GENERAL', 'manager', 'GER001', 'BILL'),
('manager_002', 'supervisor@club.com', 'SUPERVISOR', 'PRINCIPAL', 'manager', 'SUP001', 'BILL');

-- PASO 4: Insertar Closers principales (primeros 20)
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('emp_40196', 'alejandro.ortiz@club.com', 'ALEJANDRO', 'ORTIZ BENITEZ', 'closer', '40196', 'ESP'),
('emp_23314', 'alexander.buess@club.com', 'ALEXANDER', 'BUESS', 'closer', '23314', 'BILL'),
('emp_14520', 'ali.sabag@club.com', 'ALI', 'SABAG MIRAFUENTES', 'closer', '14520', 'BILL'),
('emp_68230', 'alma.aguilar@club.com', 'ALMA', 'AGUILAR MEDINA', 'closer', '68230', 'ESP'),
('emp_9959', 'andres.marron@club.com', 'ANDRES', 'MARRON ALDANA', 'closer', '9959', 'ESP'),
('emp_44034', 'arbey.acevedo@club.com', 'ARBEY', 'ACEVEDO DIAZ', 'closer', '44034', 'BILL'),
('emp_65868', 'bruno.portillo@club.com', 'BRUNO', 'PORTILLO ARRIOJA', 'closer', '65868', 'BILL'),
('emp_68879', 'carlos.flores@club.com', 'CARLOS', 'FLORES SANCHEZ', 'closer', '68879', 'BILL'),
('emp_42491', 'diana.ovando@club.com', 'DIANA', 'OVANDO VALERIANO', 'closer', '42491', 'BILL'),
('emp_38856', 'eduardo.anaya@club.com', 'EDUARDO', 'ANAYA PORTILLO', 'closer', '38856', 'BILL'),
('emp_17292', 'emanuela.garro@club.com', 'EMANUELA', 'GARRO', 'closer', '17292', 'BILL'),
('emp_68717', 'francisco.espinosa@club.com', 'FRANCISCO', 'ESPINOSA RUIZ', 'closer', '68717', 'BILL'),
('emp_65699', 'gabriel.gonzalez@club.com', 'GABRIEL', 'GONZALEZ SANCHEZ', 'closer', '65699', 'BILL'),
('emp_9506', 'gloria.brown@club.com', 'GLORIA', 'BROWN', 'closer', '9506', 'BILL'),
('emp_47029', 'ivanna.andrade@club.com', 'IVANNA', 'ANDRADE RUIZ', 'closer', '47029', 'BILL'),
('emp_26868', 'jean.loissell@club.com', 'JEAN', 'LOISSELL LAZARO', 'closer', '26868', 'BILL'),
('emp_38699', 'jessica.diaz@club.com', 'JESSICA', 'DIAZ MORENO', 'closer', '38699', 'BILL'),
('emp_9445', 'jose.jaimes@club.com', 'JOSE', 'JAIMES SERRATO', 'closer', '9445', 'BILL'),
('emp_37813', 'karen.rodriguez@club.com', 'KAREN', 'RODRIGUEZ PEREZ', 'closer', '37813', 'ESP'),
('emp_24509', 'karla.coria@club.com', 'KARLA', 'CORIA BECERRA', 'closer', '24509', 'ESP');

-- PASO 5: Insertar FTB
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('emp_68535', 'axel.jurado@club.com', 'AXEL', 'JURADO TORRES', 'ftb', '68535', 'BILL'),
('emp_51687', 'claudia.velazquez@club.com', 'CLAUDIA', 'VELAZQUEZ VELAZQUEZ', 'ftb', '51687', 'BILL'),
('emp_53494', 'ernesto.cardenas@club.com', 'ERNESTO', 'CARDENAS MONTERO', 'ftb', '53494', 'ESP'),
('emp_69078', 'sergio.castillo@club.com', 'SERGIO', 'CASTILLO PENICHE', 'ftb', '69078', 'BILL');

-- PASO 6: Insertar FTM
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('emp_67000', 'agustin.lucero@club.com', 'AGUSTIN', 'LUCERO AHUMADA', 'ftm', '67000', 'ESP'),
('emp_26044', 'alicia.salinas@club.com', 'ALICIA', 'SALINAS TORRES', 'ftm', '26044', 'BILL'),
('emp_37205', 'alison.roque@club.com', 'ALISON', 'ROQUE BUENO', 'ftm', '37205', 'BILL'),
('emp_68242', 'ana.torres@club.com', 'ANA', 'TORRES FERNANDEZ', 'ftm', '68242', 'ESP'),
('emp_64761', 'carlos.martinez@club.com', 'CARLOS', 'MARTINEZ STERNENFELS', 'ftm', '64761', 'BILL'),
('emp_49631', 'daniel.saavedra@club.com', 'DANIEL', 'SAAVEDRA URZUA', 'ftm', '49631', 'BILL'),
('emp_64520', 'daniela.lopez@club.com', 'DANIELA', 'LOPEZ KURI', 'ftm', '64520', 'ESP'),
('emp_51850', 'eduardo.pintor@club.com', 'EDUARDO', 'PINTOR ZARATE', 'ftm', '51850', 'BILL');

-- PASO 7: Insertar FTM/FTB
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('emp_17293', 'luis.islas@club.com', 'LUIS', 'ISLAS GONZALEZ', 'ftm_ftb', '17293', 'BILL');

-- PASO 8: Insertar Liners principales (primeros 15)
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('emp_68891', 'aaron.garcia@club.com', 'AARON', 'GARCIA VELAZQUEZ', 'liner', '68891', 'BILL'),
('emp_50408', 'adrian.gomez@club.com', 'ADRIAN', 'GOMEZ GOMEZ', 'liner', '50408', 'ESP'),
('emp_67901', 'alba.berenguer@club.com', 'ALBA', 'BERENGUER SOLE', 'liner', '67901', 'ESP'),
('emp_51078', 'alejandro.esquivel@club.com', 'ALEJANDRO', 'ESQUIVEL AGUIRRE', 'liner', '51078', 'BILL'),
('emp_66513', 'aline.vega@club.com', 'ALINE', 'DE LA VEGA SALCEDO', 'liner', '66513', 'ESP'),
('emp_68218', 'ana.enriquez@club.com', 'ANA', 'ENRIQUEZ CONTRERAS', 'liner', '68218', 'ESP'),
('emp_66230', 'ana.reynoso@club.com', 'ANA', 'REYNOSO REYNOSO', 'liner', '66230', 'BILL'),
('emp_68721', 'andrea.leos@club.com', 'ANDREA', 'LEOS MONREAL', 'liner', '68721', 'BILL'),
('emp_35300', 'andrea.aguirre@club.com', 'ANDREA', 'AGUIRRE ORTIZ', 'liner', '35300', 'BILL'),
('emp_38374', 'benjamin.cruz@club.com', 'BENJAMIN', 'CRUZ TELLO', 'liner', '38374', 'BILL'),
('emp_66244', 'camila.gonda@club.com', 'CAMILA', 'GONDA', 'liner', '66244', 'ESP'),
('emp_68253', 'brandon.maldonado@club.com', 'BRANDON', 'MALDONADO ORTIZ', 'liner', '68253', 'BILL'),
('emp_68234', 'david.morales@club.com', 'DAVID', 'MORALES PALACIOS', 'liner', '68234', 'ESP'),
('emp_64724', 'david.galindo@club.com', 'DAVID', 'GALINDO CAO', 'liner', '64724', 'BILL'),
('emp_23748', 'emmanuel.estrada@club.com', 'EMMANUEL', 'ESTRADA CHE', 'liner', '23748', 'ESP');

-- PASO 9: Insertar algunas calificaciones de ejemplo
INSERT INTO ratings (id, evaluator_id, evaluated_id, ratings_json, comments, date, is_anonymous) VALUES
('rating_demo_001', 'emp_68891', 'emp_40196', '{"Saludo a prospectos": 5, "Apoyo en explicación pasado/presente/futuro": 4, "Beneficios y diferenciadores": 5, "Uso del survey": 4, "Conexión entre prospectos y ejecutivos": 5}', 'Excelente closer, muy profesional', CURRENT_DATE, true),
('rating_demo_002', 'emp_40196', 'emp_68891', '{"Saludo a prospectos": 4, "Turn Over con Gusto, Uso y Dinero": 5, "Xhare Rewards": 4, "Flyback": 3, "Life Styles Experiences 365": 4, "RCI": 5, "Prime Vacation": 4, "Signature Selection": 4, "Manejo de drops": 5, "Creación de calculadora vacacional": 4}', 'Muy buen liner, sigue así', CURRENT_DATE, true),
('rating_demo_003', 'emp_50408', 'emp_23314', '{"Saludo a prospectos": 3, "Apoyo en explicación pasado/presente/futuro": 4, "Beneficios y diferenciadores": 4, "Uso del survey": 5, "Conexión entre prospectos y ejecutivos": 4}', 'Buen trabajo en general', CURRENT_DATE - INTERVAL '1 day', true);

-- PASO 10: Verificar que todo se creó correctamente
SELECT 'CLOSERS' as tipo, COUNT(*) as cantidad FROM users WHERE role = 'closer'
UNION ALL
SELECT 'LINERS' as tipo, COUNT(*) as cantidad FROM users WHERE role = 'liner'  
UNION ALL
SELECT 'FTB' as tipo, COUNT(*) as cantidad FROM users WHERE role = 'ftb'
UNION ALL
SELECT 'FTM' as tipo, COUNT(*) as cantidad FROM users WHERE role = 'ftm'
UNION ALL
SELECT 'FTM_FTB' as tipo, COUNT(*) as cantidad FROM users WHERE role = 'ftm_ftb'
UNION ALL
SELECT 'MANAGERS' as tipo, COUNT(*) as cantidad FROM users WHERE role = 'manager'
UNION ALL
SELECT 'CALIFICACIONES' as tipo, COUNT(*) as cantidad FROM ratings;