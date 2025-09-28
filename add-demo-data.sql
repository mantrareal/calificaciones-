-- Agregar más datos de prueba para demostración completa
-- Ejecutar en Supabase SQL Editor

-- Insertar más calificaciones de ejemplo
INSERT INTO ratings (id, evaluator_id, evaluated_id, ratings_json, comments, date) VALUES
('rating-demo-001', 'closer-001-sample', 'liner-001-sample', 
'{"Saludo a prospectos": 5, "Turn Over con Gusto, Uso y Dinero": 4, "Xhare Rewards": 5, "Flyback": 3, "Life Styles Experiences 365": 4, "RCI": 5, "Prime Vacation": 4, "Signature Selection": 3, "Manejo de drops": 5, "Creación de calculadora vacacional": 4}', 
'Excelente trabajo en todas las áreas. Muy profesional con los clientes.', 
CURRENT_DATE),

('rating-demo-002', 'liner-001-sample', 'closer-001-sample', 
'{"Saludo a prospectos": 4, "Apoyo en explicación pasado/presente/futuro": 5, "Beneficios y diferenciadores": 4, "Uso del survey": 5, "Conexión entre prospectos y ejecutivos": 4}', 
'Gran apoyo durante las presentaciones. Muy colaborativo.', 
CURRENT_DATE - INTERVAL '1 day'),

('rating-demo-003', 'liner-002-sample', 'closer-002-sample', 
'{"Saludo a prospectos": 3, "Apoyo en explicación pasado/presente/futuro": 4, "Beneficios y diferenciadores": 3, "Uso del survey": 4, "Conexión entre prospectos y ejecutivos": 5}', 
'Buena conexión con clientes, puede mejorar en explicaciones técnicas.', 
CURRENT_DATE - INTERVAL '2 days'),

('rating-demo-004', 'closer-002-sample', 'liner-002-sample', 
'{"Saludo a prospectos": 4, "Turn Over con Gusto, Uso y Dinero": 3, "Xhare Rewards": 4, "Flyback": 4, "Life Styles Experiences 365": 3, "RCI": 4, "Prime Vacation": 5, "Signature Selection": 4, "Manejo de drops": 3, "Creación de calculadora vacacional": 4}', 
'Buen desempeño general, mejorar en manejo de objeciones.', 
CURRENT_DATE - INTERVAL '3 days');

-- Insertar más follow-ups de ejemplo
INSERT INTO follow_ups (id, user_id, data_json) VALUES
('followup-demo-001', 'liner-001-sample', 
'{"tipoMembresia": "platino", "numeroContrato": "CT-2025-002", "nombreSocios": "Carlos y Ana Ruiz", "precio": "45000", "estatus": "procesando", "hayMoveIn": true, "fechaMoveIn": "2025-02-01"}'),

('followup-demo-002', 'liner-002-sample', 
'{"tipoMembresia": "diamante", "numeroContrato": "CT-2025-003", "nombreSocios": "Roberto y Sofia Martinez", "precio": "75000", "estatus": "completado", "hayMoveIn": false, "fechaMoveIn": ""}'),

('followup-demo-003', 'liner-001-sample', 
'{"tipoMembresia": "blue-diamond", "numeroContrato": "CT-2025-004", "nombreSocios": "Luis y Carmen Torres", "precio": "125000", "estatus": "pendiente", "hayMoveIn": true, "fechaMoveIn": "2025-03-15"}');

-- Actualizar algunos usuarios para que tengan emails más fáciles de recordar
UPDATE users SET email = 'liner@demo.com' WHERE id = 'liner-001-sample';
UPDATE users SET email = 'closer@demo.com' WHERE id = 'closer-001-sample';
UPDATE users SET email = 'manager@demo.com' WHERE id = 'manager-001-sample';