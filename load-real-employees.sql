-- Cargar empleados reales del Club Vacacional
-- Ejecutar en Supabase SQL Editor

-- Primero limpiar datos de prueba
DELETE FROM follow_ups;
DELETE FROM ratings;
DELETE FROM users;

-- Insertar todos los Closers
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('emp_40196', 'alejandro.ortiz@club.com', 'ALEJANDRO', 'ORTIZ BENITEZ', 'closer', '40196', 'ESP'),
('emp_23314', 'alexander.buess@club.com', 'ALEXANDER MARC IAN', 'BUESS', 'closer', '23314', 'BILL'),
('emp_14520', 'ali.sabag@club.com', 'ALI FAWED', 'SABAG MIRAFUENTES', 'closer', '14520', 'BILL'),
('emp_68230', 'alma.aguilar@club.com', 'ALMA MONICA', 'AGUILAR MEDINA', 'closer', '68230', 'ESP'),
('emp_9959', 'andres.marron@club.com', 'ANDRES ALEJANDRO ANTONIO', 'MARRON ALDANA', 'closer', '9959', 'ESP'),
('emp_44034', 'arbey.acevedo@club.com', 'ARBEY AHMED JESUS', 'ACEVEDO DIAZ', 'closer', '44034', 'BILL'),
('emp_65868', 'bruno.portillo@club.com', 'BRUNO MAURICIO', 'PORTILLO ARRIOJA', 'closer', '65868', 'BILL'),
('emp_68879', 'carlos.flores@club.com', 'CARLOS ISRAEL', 'FLORES SANCHEZ', 'closer', '68879', 'BILL'),
('emp_65779', 'daniel.gallop@club.com', 'DANIEL DANIEL MACDILLON', 'GALLOP BECERRA', 'closer', '65779', 'BILL'),
('emp_11113', 'daniel.medeiros@club.com', 'DANIEL VILLELA', 'PEDRAS DE MEDEIROS', 'closer', '11113', 'TRILINGUE'),
('emp_45713', 'deikson.soares@club.com', 'DEIKSON WESLEY', 'BARBOSA SOARES', 'closer', '45713', 'ESP'),
('emp_42491', 'diana.ovando@club.com', 'DIANA KARLA', 'OVANDO VALERIANO', 'closer', '42491', 'BILL'),
('emp_38856', 'eduardo.anaya@club.com', 'EDUARDO', 'ANAYA PORTILLO', 'closer', '38856', 'BILL'),
('emp_25631', 'eduardo.reyes@club.com', 'EDUARDO', 'REYES CRUZ', 'closer', '25631', 'ESP'),
('emp_17292', 'emanuela.garro@club.com', 'EMANUELA LUISA', 'GARRO', 'closer', '17292', 'BILL'),
('emp_68637', 'fausto.lopez@club.com', 'FAUSTO', 'SANTOS LOPEZ', 'closer', '68637', 'BILL'),
('emp_68717', 'francisco.espinosa@club.com', 'FRANCISCO GABRIEL', 'ESPINOSA DE LOS MONTEROS RUIZ', 'closer', '68717', 'BILL'),
('emp_65699', 'gabriel.gonzalez@club.com', 'GABRIEL', 'GONZALEZ SANCHEZ', 'closer', '65699', 'BILL'),
('emp_9506', 'gloria.brown@club.com', 'GLORIA ALEXANDRA', 'BROWN', 'closer', '9506', 'BILL'),
('emp_64389', 'guadalupe.duque@club.com', 'GUADALUPE CAROLINA', 'DUQUE MORALES', 'closer', '64389', 'BILL'),
('emp_32647', 'gustavo.orozco@club.com', 'GUSTAVO', 'OROZCO VAZQUEZ', 'closer', '32647', 'ESP'),
('emp_38708', 'irving.ponce@club.com', 'IRVING', 'PONCE RODRIGUEZ', 'closer', '38708', 'BILL'),
('emp_47029', 'ivanna.andrade@club.com', 'IVANNA AZENETT', 'ANDRADE RUIZ', 'closer', '47029', 'BILL'),
('emp_26868', 'jean.loissell@club.com', 'JEAN PAUL', 'LOISSELL LAZARO', 'closer', '26868', 'BILL'),
('emp_38699', 'jessica.diaz@club.com', 'JESSICA GUADALUPE', 'DIAZ MORENO', 'closer', '38699', 'BILL'),
('emp_9445', 'jose.jaimes@club.com', 'JOSE ALFREDO', 'JAIMES SERRATO', 'closer', '9445', 'BILL'),
('emp_26807', 'jose.servin@club.com', 'JOSE JESUS', 'SERVIN MONTESINOS', 'closer', '26807', 'BILL'),
('emp_10152', 'juan.ortega@club.com', 'JUAN CARLOS', 'ORTEGA PEREZ', 'closer', '10152', 'BILL'),
('emp_37813', 'karen.rodriguez@club.com', 'KAREN PAMELA', 'RODRIGUEZ PEREZ', 'closer', '37813', 'ESP'),
('emp_24509', 'karla.coria@club.com', 'KARLA BELEN', 'CORIA BECERRA', 'closer', '24509', 'ESP'),
('emp_68454', 'luis.gonzalez@club.com', 'LUIS JAIME', 'GONZALEZ LECHON', 'closer', '68454', 'BILL'),
('emp_26590', 'luis.vargaz@club.com', 'LUIS MANUEL', 'VARGAZ GAMBOA', 'closer', '26590', 'BILL'),
('emp_68724', 'manuel.manzano@club.com', 'MANUEL HECTOR', 'MANZANO TORRES', 'closer', '68724', 'BILL'),
('emp_10540', 'manuel.pineda@club.com', 'MANUEL', 'PINEDA ROSAS', 'closer', '10540', 'BILL'),
('emp_17968', 'maria.moreno@club.com', 'MARIA EUGENIA', 'MORENO MARTINEZ', 'closer', '17968', 'BILL'),
('emp_68989', 'maria.amaro@club.com', 'MARIA JESUS', 'AMARO RODRIGUEZ', 'closer', '68989', 'BILL'),
('emp_37337', 'maria.molina@club.com', 'MARIA MARGARITA', 'MOLINA RONQUILLO', 'closer', '37337', 'BILL'),
('emp_41695', 'nardette.zoeger@club.com', 'NARDETTE LEROY', 'ZOEGER', 'closer', '41695', 'ESP'),
('emp_51345', 'nestor.perdomo@club.com', 'NESTOR DANIEL', 'PERDOMO CANELONES', 'closer', '51345', 'ESP/PORT'),
('emp_67313', 'omar.beltran@club.com', 'OMAR', 'MORELOS BELTRAN', 'closer', '67313', 'ESP'),
('emp_38050', 'oscar.martinez@club.com', 'OSCAR EMILIO', 'MARTINEZ CONSTANTINO', 'closer', '38050', 'BILL'),
('emp_65757', 'pablo.diaz@club.com', 'PABLO GABRIEL', 'DIAZ MOYANO', 'closer', '65757', 'ESP'),
('emp_30665', 'paul.torres@club.com', 'PAUL', 'BAUTISTA TORRES', 'closer', '30665', 'ESP'),
('emp_65077', 'randy.santiesteban@club.com', 'RANDY JOSE', 'SANTIESTEBAN VALERO', 'closer', '65077', 'ESP'),
('emp_29983', 'rebeca.escamilla@club.com', 'REBECA', 'ESCAMILLA ASCENCIO', 'closer', '29983', 'BILL'),
('emp_32055', 'segundo.torres@club.com', 'SEGUNDO', 'TORRES SOUMOULOU', 'closer', '32055', 'BILL'),
('emp_17967', 'sergio.garcia@club.com', 'SERGIO LUIS', 'GARCIA GORDILLO', 'closer', '17967', 'ESP'),
('emp_68668', 'victor.acuna@club.com', 'VICTOR MANUEL', 'ACUÑA DIAZ', 'closer', '68668', 'BILL'),
('emp_29598', 'victor.sotomayor@club.com', 'VICTOR RAUL', 'SOTOMAYOR CASTILLO', 'closer', '29598', 'BILL'),
('emp_18019', 'victoria.gonzalez@club.com', 'VICTORIA ANGELICA', 'GONZALEZ CERVANTES', 'closer', '18019', 'BILL'),
('emp_68731', 'virginia.lezama@club.com', 'VIRGINIA MONSERRAT', 'LEZAMA RUIZ', 'closer', '68731', 'BILL'),
('emp_68225', 'william.ceballos@club.com', 'WILLIAM', 'CEBALLOS MURRIETA', 'closer', '68225', 'BILL'),
('emp_47256', 'ximena.leon@club.com', 'XIMENA', 'LEON MONTOYA', 'closer', '47256', 'ESP');

-- Insertar FTB
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('emp_68535', 'axel.jurado@club.com', 'AXEL BYRON', 'JURADO TORRES', 'ftb', '68535', 'BILL'),
('emp_51687', 'claudia.velazquez@club.com', 'CLAUDIA PATRICIA', 'VELAZQUEZ VELAZQUEZ', 'ftb', '51687', 'BILL'),
('emp_53494', 'ernesto.cardenas@club.com', 'ERNESTO', 'CARDENAS MONTERO', 'ftb', '53494', 'ESP'),
('emp_69078', 'sergio.castillo@club.com', 'SERGIO ABRAHAM', 'CASTILLO PENICHE', 'ftb', '69078', 'BILL');

-- Insertar FTM
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('emp_67000', 'agustin.lucero@club.com', 'AGUSTIN ADRIAN', 'LUCERO AHUMADA', 'ftm', '67000', 'ESP'),
('emp_26044', 'alicia.salinas@club.com', 'ALICIA', 'SALINAS TORRES', 'ftm', '26044', 'BILL'),
('emp_37205', 'alison.roque@club.com', 'ALISON JOSE', 'ROQUE BUENO', 'ftm', '37205', 'BILL'),
('emp_68242', 'ana.torres@club.com', 'ANA GUADALUPE', 'TORRES FERNANDEZ', 'ftm', '68242', 'ESP'),
('emp_66348', 'ariadna.fernandez@club.com', 'ARIADNA BERENICE', 'FERNANDEZ OLIVARES', 'ftm', '66348', 'ESP'),
('emp_64761', 'carlos.martinez@club.com', 'CARLOS GENEROSO', 'MARTINEZ VON STERNENFELS', 'ftm', '64761', 'BILL'),
('emp_49631', 'daniel.saavedra@club.com', 'DANIEL HUITZI', 'SAAVEDRA URZUA', 'ftm', '49631', 'BILL'),
('emp_65596', 'daniel.lopez@club.com', 'DANIEL VICENTE', 'LOPEZ FALCON', 'ftm', '65596', 'BILL'),
('emp_64520', 'daniela.lopez@club.com', 'DANIELA', 'LOPEZ KURI', 'ftm', '64520', 'ESP'),
('emp_51850', 'eduardo.pintor@club.com', 'EDUARDO', 'PINTOR ZARATE', 'ftm', '51850', 'BILL');

-- Insertar FTM/FTB
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('emp_17293', 'luis.islas@club.com', 'LUIS RICARDO', 'ISLAS GONZALEZ', 'ftm_ftb', '17293', 'BILL');

-- Crear usuarios gerenciales para pruebas
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('manager_001', 'gerencia@club.com', 'GERENCIA', 'GENERAL', 'manager', 'GER001', 'BILL'),
('manager_002', 'supervisor@club.com', 'SUPERVISOR', 'PRINCIPAL', 'manager', 'SUP001', 'BILL');

-- Continúa con algunos Liners importantes (primeros 20 para no exceder límites)
INSERT INTO users (id, email, first_name, last_name, role, employee_number, language) VALUES
('emp_68891', 'aaron.garcia@club.com', 'AARON DAVID', 'GARCIA VELAZQUEZ', 'liner', '68891', 'BILL'),
('emp_50408', 'adrian.gomez@club.com', 'ADRIAN ALEJANDRO', 'GOMEZ GOMEZ', 'liner', '50408', 'ESP'),
('emp_67901', 'alba.berenguer@club.com', 'ALBA', 'BERENGUER SOLE', 'liner', '67901', 'ESP'),
('emp_51078', 'alejandro.esquivel@club.com', 'ALEJANDRO ANTONIO', 'ESQUIVEL AGUIRRE', 'liner', '51078', 'BILL'),
('emp_66513', 'aline.vega@club.com', 'ALINE', 'DE LA VEGA SALCEDO', 'liner', '66513', 'ESP'),
('emp_64719', 'aline.hernandez@club.com', 'ALINE XIMENA', 'HERNANDEZ GUZMAN', 'liner', '64719', 'ESP'),
('emp_68991', 'allexa.montes@club.com', 'ALLEXA SOFIA', 'MONTES DE OCA ULLOA', 'liner', '68991', 'BILL'),
('emp_68218', 'ana.enriquez@club.com', 'ANA ELIZABETH', 'ENRIQUEZ CONTRERAS', 'liner', '68218', 'ESP'),
('emp_66230', 'ana.reynoso@club.com', 'ANA ROSA', 'REYNOSO REYNOSO', 'liner', '66230', 'BILL'),
('emp_16300', 'ana.zamitiz@club.com', 'ANA VICTORIA', 'ZAMITIZ ZAYAS', 'liner', '16300', 'ESP'),
('emp_68721', 'andrea.leos@club.com', 'ANDREA LIZETH', 'LEOS MONREAL', 'liner', '68721', 'BILL'),
('emp_35300', 'andrea.aguirre@club.com', 'ANDREA SELENE', 'AGUIRRE ORTIZ', 'liner', '35300', 'BILL'),
('emp_64683', 'angel.marquez@club.com', 'ANGEL MARCIAL', 'MARQUEZ PEREZ', 'liner', '64683', 'BILL'),
('emp_41657', 'antoni.sanchez@club.com', 'ANTONI ALEXANDER', 'SANCHEZ RAMOS', 'liner', '41657', 'ESP'),
('emp_67471', 'arthur.pozos@club.com', 'ARTHUR YUSEPH', 'POZOS AYALA', 'liner', '67471', 'BILL'),
('emp_66342', 'arturo.guadarrama@club.com', 'ARTURO', 'BERMAN GUADARRAMA', 'liner', '66342', 'BILL'),
('emp_38374', 'benjamin.cruz@club.com', 'BENJAMIN', 'CRUZ TELLO', 'liner', '38374', 'BILL'),
('emp_66234', 'blanca.arevalo@club.com', 'BLANCA RUTH', 'AREVALO LOPEZ', 'liner', '66234', 'ESP'),
('emp_68253', 'brandon.maldonado@club.com', 'BRANDON', 'MALDONADO ORTIZ', 'liner', '68253', 'BILL'),
('emp_66244', 'camila.gonda@club.com', 'CAMILA REINA', 'GONDA', 'liner', '66244', 'ESP');