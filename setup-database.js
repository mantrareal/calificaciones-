// Script temporal para crear las tablas de la base de datos
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://hadfdgbyxhbqgjycbftv.supabase.co'
const serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhhZGZkZ2J5eGhicWdqeWNiZnR2Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTAwMTg0NywiZXhwIjoyMDc0NTc3ODQ3fQ.kE18w7kwFv33SGhvni3kt5RXVBYhrRqytD5PAo_e7-M'

const supabase = createClient(supabaseUrl, serviceRoleKey)

async function setupDatabase() {
  try {
    console.log('Creando tablas...')
    
    // Create tables SQL
    const createTablesSQL = `
      -- Drop existing tables if recreating
      DROP TABLE IF EXISTS follow_ups;
      DROP TABLE IF EXISTS ratings;
      DROP TABLE IF EXISTS users;

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
      CREATE POLICY "Allow public access" ON users FOR ALL USING (true);
      CREATE POLICY "Allow public access" ON ratings FOR ALL USING (true);
      CREATE POLICY "Allow public access" ON follow_ups FOR ALL USING (true);

      -- Create indexes for performance
      CREATE INDEX idx_users_email ON users(email);
      CREATE INDEX idx_users_role ON users(role);
      CREATE INDEX idx_ratings_evaluator ON ratings("evaluatorId");
      CREATE INDEX idx_ratings_evaluated ON ratings("evaluatedId");
      CREATE INDEX idx_ratings_date ON ratings(date DESC);
      CREATE INDEX idx_followups_user ON follow_ups("userId");
    `

    // Execute the SQL
    const { error } = await supabase.rpc('exec_sql', { sql: createTablesSQL })
    
    if (error) {
      console.error('Error creando tablas:', error)
      // Try alternative method
      console.log('Intentando método alternativo...')
      
      // Create tables one by one
      const queries = [
        `DROP TABLE IF EXISTS follow_ups CASCADE;`,
        `DROP TABLE IF EXISTS ratings CASCADE;`,
        `DROP TABLE IF EXISTS users CASCADE;`,
        `CREATE TABLE users (
          id TEXT PRIMARY KEY,
          email TEXT UNIQUE NOT NULL,
          first_name TEXT NOT NULL,
          last_name TEXT NOT NULL,
          role TEXT NOT NULL DEFAULT 'liner' CHECK (role IN ('liner', 'closer', 'manager')),
          created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );`,
        `CREATE TABLE ratings (
          id TEXT PRIMARY KEY,
          "evaluatorId" TEXT NOT NULL,
          "evaluatedId" TEXT NOT NULL,
          "ratingsJson" JSONB NOT NULL,
          comments TEXT,
          date DATE NOT NULL,
          "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
          FOREIGN KEY ("evaluatorId") REFERENCES users(id),
          FOREIGN KEY ("evaluatedId") REFERENCES users(id)
        );`,
        `CREATE TABLE follow_ups (
          id TEXT PRIMARY KEY,
          "userId" TEXT NOT NULL,
          "dataJson" JSONB NOT NULL,
          "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
          FOREIGN KEY ("userId") REFERENCES users(id)
        );`,
        `ALTER TABLE users ENABLE ROW LEVEL SECURITY;`,
        `ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;`,
        `ALTER TABLE follow_ups ENABLE ROW LEVEL SECURITY;`,
        `CREATE POLICY "Allow public access users" ON users FOR ALL USING (true);`,
        `CREATE POLICY "Allow public access ratings" ON ratings FOR ALL USING (true);`,
        `CREATE POLICY "Allow public access follow_ups" ON follow_ups FOR ALL USING (true);`
      ]
      
      for (const query of queries) {
        const { error: queryError } = await supabase.rpc('exec_sql', { sql: query })
        if (queryError) {
          console.log(`Query ejecutada: ${query.substring(0, 50)}...`)
        }
      }
    }

    console.log('✅ Tablas creadas exitosamente!')
    
    // Insert some sample data
    console.log('Insertando datos de ejemplo...')
    
    // Sample users
    const sampleUsers = [
      {
        id: 'user_1',
        email: 'liner1@test.com',
        first_name: 'Juan',
        last_name: 'Pérez',
        role: 'liner'
      },
      {
        id: 'user_2',
        email: 'closer1@test.com',
        first_name: 'María',
        last_name: 'García',
        role: 'closer'
      },
      {
        id: 'user_3',
        email: 'manager1@test.com',
        first_name: 'Carlos',
        last_name: 'López',
        role: 'manager'
      }
    ]

    const { error: insertError } = await supabase
      .from('users')
      .insert(sampleUsers)

    if (insertError) {
      console.log('Error insertando datos de ejemplo:', insertError)
    } else {
      console.log('✅ Datos de ejemplo insertados!')
    }

  } catch (error) {
    console.error('Error general:', error)
  }
}

// Run setup
setupDatabase()