import { NextResponse } from 'next/server'
import { supabase, generateId } from '../../../lib/supabase.js'

// Initialize database tables if they don't exist
async function initializeDatabase() {
  try {
    // Check if tables exist by trying to query them
    const { data: users } = await supabase
      .from('users')
      .select('id')
      .limit(1)
    
    // If no error, tables exist
    return true
  } catch (error) {
    // Tables don't exist, create them
    console.log('Creating database tables...')
    
    const createUsersTable = `
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'liner' CHECK (role IN ('liner', 'closer', 'manager')),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );
    `
    
    const createRatingsTable = `
      CREATE TABLE IF NOT EXISTS ratings (
        id TEXT PRIMARY KEY,
        evaluator_id TEXT NOT NULL,
        evaluated_id TEXT NOT NULL,
        ratings_json JSONB NOT NULL,
        comments TEXT,
        date DATE NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );
    `
    
    const createFollowUpsTable = `
      CREATE TABLE IF NOT EXISTS follow_ups (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        data_json JSONB NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );
    `
    
    // Execute table creation (Note: This might not work with RLS, but we'll try)
    try {
      await supabase.rpc('exec_sql', { sql: createUsersTable })
      await supabase.rpc('exec_sql', { sql: createRatingsTable })
      await supabase.rpc('exec_sql', { sql: createFollowUpsTable })
    } catch (sqlError) {
      console.log('SQL execution via RPC failed, tables might already exist')
    }
    
    // Insert sample data if tables are empty
    const { data: existingUsers } = await supabase
      .from('users')
      .select('id')
      .limit(1)
    
    if (!existingUsers || existingUsers.length === 0) {
      const sampleUsers = [
        {
          id: generateId(),
          email: 'liner1@test.com',
          first_name: 'Juan',
          last_name: 'Pérez',
          role: 'liner'
        },
        {
          id: generateId(),
          email: 'closer1@test.com',
          first_name: 'María',
          last_name: 'García',
          role: 'closer'
        },
        {
          id: generateId(),
          email: 'manager1@test.com',
          first_name: 'Carlos',
          last_name: 'López',
          role: 'manager'
        },
        {
          id: generateId(),
          email: 'liner2@test.com',
          first_name: 'Ana',
          last_name: 'Martínez',
          role: 'liner'
        },
        {
          id: generateId(),
          email: 'closer2@test.com',
          first_name: 'Roberto',
          last_name: 'Sánchez',
          role: 'closer'
        }
      ]

      try {
        await supabase.from('users').insert(sampleUsers)
        console.log('Sample users inserted')
      } catch (insertError) {
        console.log('Error inserting sample users:', insertError)
      }
    }
    
    return true
  }
}

export async function GET(request) {
  try {
    await initializeDatabase()
    
    const { pathname } = new URL(request.url)
    const pathSegments = pathname.split('/').filter(Boolean)
    
    // Remove 'api' from path segments
    const cleanPath = pathSegments.slice(1).join('/')
    
    switch (cleanPath) {
      case 'users':
        const { data: users, error: usersError } = await supabase
          .from('users')
          .select('*')
          .order('created_at', { ascending: false })
        
        if (usersError) {
          return NextResponse.json({ error: usersError.message }, { status: 500 })
        }
        
        return NextResponse.json(users || [])
      
      case 'ratings':
        const { data: ratings, error: ratingsError } = await supabase
          .from('ratings')
          .select('*')
          .order('created_at', { ascending: false })
        
        if (ratingsError) {
          return NextResponse.json({ error: ratingsError.message }, { status: 500 })
        }
        
        return NextResponse.json(ratings || [])
      
      case 'follow-ups':
        const { data: followUps, error: followUpsError } = await supabase
          .from('follow_ups')
          .select('*')
          .order('created_at', { ascending: false })
        
        if (followUpsError) {
          return NextResponse.json({ error: followUpsError.message }, { status: 500 })
        }
        
        return NextResponse.json(followUps || [])
      
      default:
        return NextResponse.json({ 
          message: 'Club Vacacional API',
          endpoints: ['/api/users', '/api/ratings', '/api/follow-ups'],
          status: 'active'
        })
    }
  } catch (error) {
    console.error('API Error:', error)
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
  }
}

export async function POST(request) {
  try {
    await initializeDatabase()
    
    const { pathname } = new URL(request.url)
    const pathSegments = pathname.split('/').filter(Boolean)
    const cleanPath = pathSegments.slice(1).join('/')
    const body = await request.json()
    
    switch (cleanPath) {
      case 'users':
        const userData = {
          id: generateId(),
          ...body
        }
        
        const { data: newUser, error: userError } = await supabase
          .from('users')
          .insert([userData])
          .select()
          .single()
        
        if (userError) {
          return NextResponse.json({ error: userError.message }, { status: 500 })
        }
        
        return NextResponse.json(newUser)
      
      case 'ratings':
        const ratingData = {
          id: generateId(),
          ...body
        }
        
        const { data: newRating, error: ratingError } = await supabase
          .from('ratings')
          .insert([ratingData])
          .select()
          .single()
        
        if (ratingError) {
          return NextResponse.json({ error: ratingError.message }, { status: 500 })
        }
        
        return NextResponse.json(newRating)
      
      case 'follow-ups':
        const followUpData = {
          id: generateId(),
          ...body
        }
        
        const { data: newFollowUp, error: followUpError } = await supabase
          .from('follow_ups')
          .insert([followUpData])
          .select()
          .single()
        
        if (followUpError) {
          return NextResponse.json({ error: followUpError.message }, { status: 500 })
        }
        
        return NextResponse.json(newFollowUp)
      
      default:
        return NextResponse.json({ error: 'Endpoint not found' }, { status: 404 })
    }
  } catch (error) {
    console.error('POST API Error:', error)
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
  }
}

export async function PUT(request) {
  try {
    const { pathname } = new URL(request.url)
    const pathSegments = pathname.split('/').filter(Boolean)
    const cleanPath = pathSegments.slice(1).join('/')
    const body = await request.json()
    
    // Handle updates if needed
    return NextResponse.json({ message: 'PUT method not implemented yet' }, { status: 501 })
  } catch (error) {
    console.error('PUT API Error:', error)
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
  }
}

export async function DELETE(request) {
  try {
    const { pathname } = new URL(request.url)
    const pathSegments = pathname.split('/').filter(Boolean)
    const cleanPath = pathSegments.slice(1).join('/')
    
    // Handle deletes if needed
    return NextResponse.json({ message: 'DELETE method not implemented yet' }, { status: 501 })
  } catch (error) {
    console.error('DELETE API Error:', error)
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
  }
}