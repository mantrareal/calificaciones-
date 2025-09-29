import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Utility functions
export const generateId = () => `id_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`

// Auth functions
export const auth = {
  signUp: async (email, password, selectedEmployeeId) => {
    try {
      // Check if user already exists
      const { data: existingUser } = await supabase
        .from('users')
        .select('*')
        .eq('email', email)

      if (existingUser && existingUser.length > 0) {
        return { data: null, error: { message: 'Usuario ya existe con este email' } }
      }

      // Check if employee is already taken
      const { data: employee } = await supabase
        .from('available_employees')
        .select('*')
        .eq('id', selectedEmployeeId)
        .single()

      if (!employee) {
        return { data: null, error: { message: 'Empleado no encontrado' } }
      }

      if (employee.is_taken) {
        return { data: null, error: { message: 'Este empleado ya está registrado' } }
      }

      // Create new user
      const userId = generateId()
      const { data, error } = await supabase
        .from('users')
        .insert([{
          id: userId,
          email,
          employee_id: selectedEmployeeId
        }])
        .select()

      if (error) {
        console.error('Database insert error:', error)
        return { data: null, error: { message: 'Error al crear usuario: ' + error.message } }
      }

      // Mark employee as taken
      await supabase
        .from('available_employees')
        .update({ is_taken: true })
        .eq('id', selectedEmployeeId)

      // Get user with employee data
      const { data: fullUser } = await supabase
        .from('users')
        .select(`
          *,
          available_employees (*)
        `)
        .eq('id', userId)
        .single()

      return { data: fullUser, error: null }
    } catch (error) {
      console.error('SignUp error:', error)
      return { data: null, error: { message: 'Error al registrar usuario: ' + error.message } }
    }
  },

  signIn: async (email, password) => {
    try {
      const { data, error } = await supabase
        .from('users')
        .select(`
          *,
          available_employees (*)
        `)
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