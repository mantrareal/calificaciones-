import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Utility functions
export const generateId = () => `id_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`

// Auth functions
export const auth = {
  signUp: async (email, password, firstName, lastName) => {
    try {
      // For simplicity, we'll just create a user record directly
      // In production, you'd use Supabase Auth
      const userId = generateId()
      const { data, error } = await supabase
        .from('users')
        .insert([{
          id: userId,
          email,
          first_name: firstName,
          last_name: lastName,
          role: 'liner' // Default role
        }])
        .select()
        .single()

      if (error) throw error
      return { data, error: null }
    } catch (error) {
      return { data: null, error }
    }
  },

  signIn: async (email, password) => {
    try {
      const { data, error } = await supabase
        .from('users')
        .select('*')
        .eq('email', email)

      if (error) {
        console.error('Database error:', error)
        return { data: null, error: { message: 'Error de conexión a la base de datos' } }
      }

      if (!data || data.length === 0) {
        return { data: null, error: { message: 'Usuario no encontrado' } }
      }

      if (data.length > 1) {
        console.error('Multiple users found for email:', email)
        return { data: null, error: { message: 'Error: múltiples usuarios encontrados' } }
      }

      return { data: data[0], error: null }
    } catch (error) {
      console.error('SignIn error:', error)
      return { data: null, error: { message: 'Error al iniciar sesión: ' + error.message } }
    }
  },

  getCurrentUser: () => {
    if (typeof window !== 'undefined') {
      const user = localStorage.getItem('currentUser')
      return user ? JSON.parse(user) : null
    }
    return null
  },

  setCurrentUser: (user) => {
    if (typeof window !== 'undefined') {
      localStorage.setItem('currentUser', JSON.stringify(user))
    }
  },

  signOut: () => {
    if (typeof window !== 'undefined') {
      localStorage.removeItem('currentUser')
    }
  }
}