-- SCRIPT COMPLETO TODOS LOS EMPLEADOS CLUB VACACIONAL
-- Ejecutar en Supabase SQL Editor

-- PASO 1: Limpiar datos anteriores
DELETE FROM follow_ups;
DELETE FROM ratings;
DELETE FROM users;

-- PASO 2: Actualizar estructura
ALTER TABLE users ADD COLUMN IF NOT EXISTS employee_number TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS language TEXT DEFAULT 'BILL';

-- PASO 3: Usuarios gerenciales
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('manager_001', 'gerencia@club.com', 'GERENCIA', 'GENERAL', 'manager', 'GER001', 'BILL'),
('manager_002', 'supervisor@club.com', 'SUPERVISOR', 'PRINCIPAL', 'manager', 'SUP001', 'BILL');

-- PASO 4: TODOS LOS CLOSERS (51 empleados)
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('emp_40196', 'alejandro.ortiz40196@club.com', 'ALEJANDRO', 'ORTIZ BENITEZ', 'closer', '40196', 'ESP'),
('emp_23314', 'alexander.buess23314@club.com', 'ALEXANDER MARC IAN', 'BUESS', 'closer', '23314', 'BILL'),
('emp_14520', 'ali.sabag14520@club.com', 'ALI FAWED', 'SABAG MIRAFUENTES', 'closer', '14520', 'BILL'),
('emp_68230', 'alma.aguilar68230@club.com', 'ALMA MONICA', 'AGUILAR MEDINA', 'closer', '68230', 'ESP'),
('emp_9959', 'andres.marron9959@club.com', 'ANDRES ALEJANDRO ANTONIO', 'MARRON ALDANA', 'closer', '9959', 'ESP'),
('emp_44034', 'arbey.acevedo44034@club.com', 'ARBEY AHMED JESUS', 'ACEVEDO DIAZ', 'closer', '44034', 'BILL'),
('emp_65868', 'bruno.portillo65868@club.com', 'BRUNO MAURICIO', 'PORTILLO ARRIOJA', 'closer', '65868', 'BILL'),
('emp_68879', 'carlos.flores68879@club.com', 'CARLOS ISRAEL', 'FLORES SANCHEZ', 'closer', '68879', 'BILL'),
('emp_65779', 'daniel.gallop65779@club.com', 'DANIEL DANIEL MACDILLON', 'GALLOP BECERRA', 'closer', '65779', 'BILL'),
('emp_11113', 'daniel.medeiros11113@club.com', 'DANIEL VILLELA', 'PEDRAS DE MEDEIROS', 'closer', '11113', 'TRILINGUE'),
('emp_45713', 'deikson.soares45713@club.com', 'DEIKSON WESLEY', 'BARBOSA SOARES', 'closer', '45713', 'ESP'),
('emp_42491', 'diana.ovando42491@club.com', 'DIANA KARLA', 'OVANDO VALERIANO', 'closer', '42491', 'BILL'),
('emp_38856', 'eduardo.anaya38856@club.com', 'EDUARDO', 'ANAYA PORTILLO', 'closer', '38856', 'BILL'),
('emp_25631', 'eduardo.reyes25631@club.com', 'EDUARDO', 'REYES CRUZ', 'closer', '25631', 'ESP'),
('emp_17292', 'emanuela.garro17292@club.com', 'EMANUELA LUISA', 'GARRO', 'closer', '17292', 'BILL'),
('emp_68637', 'fausto.lopez68637@club.com', 'FAUSTO', 'SANTOS LOPEZ', 'closer', '68637', 'BILL'),
('emp_68717', 'francisco.espinosa68717@club.com', 'FRANCISCO GABRIEL', 'ESPINOSA DE LOS MONTEROS RUIZ', 'closer', '68717', 'BILL'),
('emp_65699', 'gabriel.gonzalez65699@club.com', 'GABRIEL', 'GONZALEZ SANCHEZ', 'closer', '65699', 'BILL'),
('emp_9506', 'gloria.brown9506@club.com', 'GLORIA ALEXANDRA', 'BROWN', 'closer', '9506', 'BILL'),
('emp_64389', 'guadalupe.duque64389@club.com', 'GUADALUPE CAROLINA', 'DUQUE MORALES', 'closer', '64389', 'BILL'),
('emp_32647', 'gustavo.orozco32647@club.com', 'GUSTAVO', 'OROZCO VAZQUEZ', 'closer', '32647', 'ESP'),
('emp_38708', 'irving.ponce38708@club.com', 'IRVING', 'PONCE RODRIGUEZ', 'closer', '38708', 'BILL'),
('emp_47029', 'ivanna.andrade47029@club.com', 'IVANNA AZENETT', 'ANDRADE RUIZ', 'closer', '47029', 'BILL'),
('emp_26868', 'jean.loissell26868@club.com', 'JEAN PAUL', 'LOISSELL LAZARO', 'closer', '26868', 'BILL'),
('emp_38699', 'jessica.diaz38699@club.com', 'JESSICA GUADALUPE', 'DIAZ MORENO', 'closer', '38699', 'BILL'),
('emp_9445', 'jose.jaimes9445@club.com', 'JOSE ALFREDO', 'JAIMES SERRATO', 'closer', '9445', 'BILL'),
('emp_26807', 'jose.servin26807@club.com', 'JOSE JESUS', 'SERVIN MONTESINOS', 'closer', '26807', 'BILL'),
('emp_10152', 'juan.ortega10152@club.com', 'JUAN CARLOS', 'ORTEGA PEREZ', 'closer', '10152', 'BILL'),
('emp_37813', 'karen.rodriguez37813@club.com', 'KAREN PAMELA', 'RODRIGUEZ PEREZ', 'closer', '37813', 'ESP'),
('emp_24509', 'karla.coria24509@club.com', 'KARLA BELEN', 'CORIA BECERRA', 'closer', '24509', 'ESP'),
('emp_68454', 'luis.gonzalez68454@club.com', 'LUIS JAIME', 'GONZALEZ LECHON', 'closer', '68454', 'BILL'),
('emp_26590', 'luis.vargaz26590@club.com', 'LUIS MANUEL', 'VARGAZ GAMBOA', 'closer', '26590', 'BILL'),
('emp_68724', 'manuel.manzano68724@club.com', 'MANUEL HECTOR', 'MANZANO TORRES', 'closer', '68724', 'BILL'),
('emp_10540', 'manuel.pineda10540@club.com', 'MANUEL', 'PINEDA ROSAS', 'closer', '10540', 'BILL'),
('emp_17968', 'maria.moreno17968@club.com', 'MARIA EUGENIA', 'MORENO MARTINEZ', 'closer', '17968', 'BILL'),
('emp_68989', 'maria.amaro68989@club.com', 'MARIA JESUS', 'AMARO RODRIGUEZ', 'closer', '68989', 'BILL'),
('emp_37337', 'maria.molina37337@club.com', 'MARIA MARGARITA', 'MOLINA RONQUILLO', 'closer', '37337', 'BILL'),
('emp_41695', 'nardette.zoeger41695@club.com', 'NARDETTE LEROY', 'ZOEGER', 'closer', '41695', 'ESP'),
('emp_51345', 'nestor.perdomo51345@club.com', 'NESTOR DANIEL', 'PERDOMO CANELONES', 'closer', '51345', 'ESP/PORT'),
('emp_67313', 'omar.beltran67313@club.com', 'OMAR', 'MORELOS BELTRAN', 'closer', '67313', 'ESP'),
('emp_38050', 'oscar.martinez38050@club.com', 'OSCAR EMILIO', 'MARTINEZ CONSTANTINO', 'closer', '38050', 'BILL'),
('emp_65757', 'pablo.diaz65757@club.com', 'PABLO GABRIEL', 'DIAZ MOYANO', 'closer', '65757', 'ESP'),
('emp_30665', 'paul.torres30665@club.com', 'PAUL', 'BAUTISTA TORRES', 'closer', '30665', 'ESP'),
('emp_65077', 'randy.santiesteban65077@club.com', 'RANDY JOSE', 'SANTIESTEBAN VALERO', 'closer', '65077', 'ESP'),
('emp_29983', 'rebeca.escamilla29983@club.com', 'REBECA', 'ESCAMILLA ASCENCIO', 'closer', '29983', 'BILL'),
('emp_32055', 'segundo.torres32055@club.com', 'SEGUNDO', 'TORRES SOUMOULOU', 'closer', '32055', 'BILL'),
('emp_17967', 'sergio.garcia17967@club.com', 'SERGIO LUIS', 'GARCIA GORDILLO', 'closer', '17967', 'ESP'),
('emp_68668', 'victor.acuna68668@club.com', 'VICTOR MANUEL', 'ACUÑA DIAZ', 'closer', '68668', 'BILL'),
('emp_29598', 'victor.sotomayor29598@club.com', 'VICTOR RAUL', 'SOTOMAYOR CASTILLO', 'closer', '29598', 'BILL'),
('emp_18019', 'victoria.gonzalez18019@club.com', 'VICTORIA ANGELICA', 'GONZALEZ CERVANTES', 'closer', '18019', 'BILL'),
('emp_68731', 'virginia.lezama68731@club.com', 'VIRGINIA MONSERRAT', 'LEZAMA RUIZ', 'closer', '68731', 'BILL'),
('emp_68225', 'william.ceballos68225@club.com', 'WILLIAM', 'CEBALLOS MURRIETA', 'closer', '68225', 'BILL'),
('emp_47256', 'ximena.leon47256@club.com', 'XIMENA', 'LEON MONTOYA', 'closer', '47256', 'ESP');

-- PASO 5: TODOS LOS FTB (4 empleados)
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('emp_68535', 'axel.jurado68535@club.com', 'AXEL BYRON', 'JURADO TORRES', 'ftb', '68535', 'BILL'),
('emp_51687', 'claudia.velazquez51687@club.com', 'CLAUDIA PATRICIA', 'VELAZQUEZ VELAZQUEZ', 'ftb', '51687', 'BILL'),
('emp_53494', 'ernesto.cardenas53494@club.com', 'ERNESTO', 'CARDENAS MONTERO', 'ftb', '53494', 'ESP'),
('emp_69078', 'sergio.castillo69078@club.com', 'SERGIO ABRAHAM', 'CASTILLO PENICHE', 'ftb', '69078', 'BILL');

-- CONTINÚA EN PRÓXIMO MENSAJE... (El resto de FTM y LINERS)

-- VERIFICAR CLOSERS Y FTB CREADOS
SELECT 'CLOSERS CREADOS' as status, COUNT(*) as cantidad FROM users WHERE role = 'closer'
UNION ALL
SELECT 'FTB CREADOS' as status, COUNT(*) as cantidad FROM users WHERE role = 'ftb';