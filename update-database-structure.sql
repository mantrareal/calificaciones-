-- Actualizar estructura de base de datos para sistema profesional
-- Ejecutar en Supabase SQL Editor

-- Agregar campos nuevos a la tabla users
ALTER TABLE users ADD COLUMN IF NOT EXISTS employee_number TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS language TEXT DEFAULT 'BILL';

-- Actualizar tabla ratings para incluir anonimidad
ALTER TABLE ratings ADD COLUMN IF NOT EXISTS is_anonymous BOOLEAN DEFAULT true;
ALTER TABLE ratings ADD COLUMN IF NOT EXISTS rating_period DATE DEFAULT CURRENT_DATE;

-- Crear tabla para rankings
CREATE TABLE IF NOT EXISTS rankings (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  position INTEGER NOT NULL,
  average_score DECIMAL(3,2) NOT NULL,
  total_ratings INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Crear tabla para reportes gerenciales
CREATE TABLE IF NOT EXISTS management_reports (
  id TEXT PRIMARY KEY,
  report_type TEXT NOT NULL CHECK (report_type IN ('daily', 'weekly', 'monthly')),
  report_date DATE NOT NULL,
  data_json JSONB NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS para nuevas tablas
ALTER TABLE rankings ENABLE ROW LEVEL SECURITY;
ALTER TABLE management_reports ENABLE ROW LEVEL SECURITY;

-- Crear políticas para rankings
CREATE POLICY "Allow public access rankings" ON rankings FOR ALL USING (true);
CREATE POLICY "Allow public access management_reports" ON management_reports FOR ALL USING (true);

-- Crear índices para mejor performance
CREATE INDEX IF NOT EXISTS idx_users_employee_number ON users(employee_number);
CREATE INDEX IF NOT EXISTS idx_users_language ON users(language);
CREATE INDEX IF NOT EXISTS idx_rankings_user_period ON rankings(user_id, period_start, period_end);
CREATE INDEX IF NOT EXISTS idx_rankings_position ON rankings(position);
CREATE INDEX IF NOT EXISTS idx_reports_type_date ON management_reports(report_type, report_date);

-- Función para calcular promedios
CREATE OR REPLACE FUNCTION calculate_user_average(user_id_param TEXT)
RETURNS DECIMAL(3,2) AS $$
DECLARE
  avg_score DECIMAL(3,2);
BEGIN
  SELECT AVG(
    (
      SELECT AVG(value::numeric)
      FROM jsonb_each_text(ratings_json)
      WHERE value ~ '^[0-9]+(\.[0-9]+)?$'
    )
  ) INTO avg_score
  FROM ratings
  WHERE evaluated_id = user_id_param;
  
  RETURN COALESCE(avg_score, 0.00);
END;
$$ LANGUAGE plpgsql;

-- Función para generar ranking
CREATE OR REPLACE FUNCTION generate_rankings(start_date DATE, end_date DATE)
RETURNS TABLE(
  user_id TEXT,
  full_name TEXT,
  role TEXT,
  employee_number TEXT,
  average_score DECIMAL(3,2),
  total_ratings BIGINT,
  position INTEGER
) AS $$
BEGIN
  RETURN QUERY
  WITH user_scores AS (
    SELECT 
      u.id as user_id,
      CONCAT(u.first_name, ' ', u.last_name) as full_name,
      u.role,
      u.employee_number,
      COALESCE(
        AVG(
          (
            SELECT AVG(value::numeric)
            FROM jsonb_each_text(r.ratings_json)
            WHERE value ~ '^[0-9]+(\.[0-9]+)?$'
          )
        ), 0
      )::DECIMAL(3,2) as average_score,
      COUNT(r.id) as total_ratings
    FROM users u
    LEFT JOIN ratings r ON u.id = r.evaluated_id 
      AND r.date BETWEEN start_date AND end_date
    WHERE u.role IN ('closer', 'liner', 'ftb', 'ftm', 'ftm_ftb')
    GROUP BY u.id, u.first_name, u.last_name, u.role, u.employee_number
  )
  SELECT 
    us.user_id,
    us.full_name,
    us.role,
    us.employee_number,
    us.average_score,
    us.total_ratings,
    ROW_NUMBER() OVER (ORDER BY us.average_score DESC, us.total_ratings DESC)::INTEGER as position
  FROM user_scores us
  ORDER BY position;
END;
$$ LANGUAGE plpgsql;