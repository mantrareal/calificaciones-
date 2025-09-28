'use client'

import { useState, useEffect } from 'react'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { StarRating } from '@/components/ui/star-rating'
import { RatingCard } from '@/components/ui/rating-card'
import { auth } from '@/lib/supabase'
import { 
  Users, 
  Star, 
  LogOut, 
  ClipboardList, 
  BarChart3,
  UserCheck,
  UserX,
  Calendar,
  MessageSquare,
  Award,
  TrendingUp
} from 'lucide-react'

export default function App() {
  const [currentUser, setCurrentUser] = useState(null)
  const [view, setView] = useState('login') // login, register, dashboard, rate-closer, rate-liner, my-ratings, follow-up
  const [users, setUsers] = useState([])
  const [ratings, setRatings] = useState([])
  const [myRatings, setMyRatings] = useState([])

  // Login/Register state
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [firstName, setFirstName] = useState('')
  const [lastName, setLastName] = useState('')

  // Rating state
  const [selectedUserId, setSelectedUserId] = useState('')
  const [ratingData, setRatingData] = useState({})
  const [comments, setComments] = useState('')

  // Follow-up state
  const [followUpData, setFollowUpData] = useState({
    tipoMembresia: '',
    numeroContrato: '',
    nombreSocios: '',
    precio: '',
    estatus: '',
    hayMoveIn: false,
    fechaMoveIn: ''
  })

  useEffect(() => {
    const user = auth.getCurrentUser()
    if (user) {
      setCurrentUser(user)
      setView('dashboard')
      fetchData()
    }
  }, [])

  const fetchData = async () => {
    try {
      // Fetch users
      const response = await fetch('/api/users')
      if (response.ok) {
        const userData = await response.json()
        setUsers(userData)
      }

      // Fetch ratings
      const ratingsResponse = await fetch('/api/ratings')
      if (ratingsResponse.ok) {
        const ratingsData = await ratingsResponse.json()
        setRatings(ratingsData)
        
        // Filter my ratings (where I was evaluated)
        const user = auth.getCurrentUser()
        if (user) {
          const myRatingsData = ratingsData.filter(rating => rating.evaluated_id === user.id)
          setMyRatings(myRatingsData)
        }
      }
    } catch (error) {
      console.error('Error fetching data:', error)
    }
  }

  const handleLogin = async (e) => {
    e.preventDefault()
    const { data, error } = await auth.signIn(email, password)
    
    if (error) {
      alert('Error: ' + error.message)
      return
    }

    auth.setCurrentUser(data)
    setCurrentUser(data)
    setView('dashboard')
    fetchData()
  }

  const handleRegister = async (e) => {
    e.preventDefault()
    const { data, error } = await auth.signUp(email, password, firstName, lastName)
    
    if (error) {
      alert('Error: ' + error.message)
      return
    }

    auth.setCurrentUser(data)
    setCurrentUser(data)
    setView('dashboard')
    fetchData()
  }

  const handleLogout = () => {
    auth.signOut()
    setCurrentUser(null)
    setView('login')
  }

  const handleRatingChange = (category, value) => {
    setRatingData(prev => ({
      ...prev,
      [category]: value
    }))
  }

  const submitRating = async () => {
    if (!selectedUserId) {
      alert('Por favor selecciona un usuario para calificar')
      return
    }

    const ratingPayload = {
      evaluator_id: currentUser.id,
      evaluated_id: selectedUserId,
      ratings_json: ratingData,
      comments,
      date: new Date().toISOString().split('T')[0]
    }

    try {
      const response = await fetch('/api/ratings', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(ratingPayload)
      })

      if (response.ok) {
        alert('Calificación enviada exitosamente!')
        setSelectedUserId('')
        setRatingData({})
        setComments('')
        setView('dashboard')
        fetchData()
      } else {
        alert('Error al enviar calificación')
      }
    } catch (error) {
      console.error('Error submitting rating:', error)
      alert('Error al enviar calificación')
    }
  }

  const submitFollowUp = async () => {
    try {
      const response = await fetch('/api/follow-ups', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          user_id: currentUser.id,
          data_json: followUpData
        })
      })

      if (response.ok) {
        alert('Follow-up guardado exitosamente!')
        setFollowUpData({
          tipoMembresia: '',
          numeroContrato: '',
          nombreSocios: '',
          precio: '',
          estatus: '',
          hayMoveIn: false,
          fechaMoveIn: ''
        })
        setView('dashboard')
      } else {
        alert('Error al guardar follow-up')
      }
    } catch (error) {
      console.error('Error submitting follow-up:', error)
      alert('Error al guardar follow-up')
    }
  }

  // Define rating categories based on role
  const getLinerRatingCategories = () => [
    'Saludo a prospectos',
    'Turn Over con Gusto, Uso y Dinero',
    'Xhare Rewards',
    'Flyback',
    'Life Styles Experiences 365',
    'RCI',
    'Prime Vacation',
    'Signature Selection',
    'Manejo de drops',
    'Creación de calculadora vacacional'
  ]

  const getCloserRatingCategories = () => [
    'Saludo a prospectos',
    'Apoyo en explicación pasado/presente/futuro',
    'Beneficios y diferenciadores',
    'Uso del survey',
    'Conexión entre prospectos y ejecutivos'
  ]

  const getFilteredUsers = () => {
    if (!currentUser) return []
    
    if (currentUser.role === 'liner') {
      return users.filter(user => user.role === 'closer')
    } else if (currentUser.role === 'closer') {
      return users.filter(user => user.role === 'liner')
    }
    return []
  }

  const getRatingCategories = () => {
    if (view === 'rate-closer') {
      return getLinerRatingCategories()
    } else if (view === 'rate-liner') {
      return getCloserRatingCategories()
    }
    return []
  }

  if (!currentUser) {
    return (
      <div className="min-h-screen gradient-bg flex items-center justify-center p-4">
        <Card className="w-full max-w-md glass-card border-white/20">
          <CardHeader className="text-center">
            <CardTitle className="text-2xl font-bold text-white">
              Club Vacacional
            </CardTitle>
            <p className="text-white/80">Sistema de Calificación</p>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex space-x-2 mb-4">
              <Button 
                variant={view === 'login' ? 'default' : 'outline'}
                onClick={() => setView('login')}
                className="flex-1"
              >
                Iniciar Sesión
              </Button>
              <Button 
                variant={view === 'register' ? 'default' : 'outline'}
                onClick={() => setView('register')}
                className="flex-1"
              >
                Registrarse
              </Button>
            </div>

            <form onSubmit={view === 'login' ? handleLogin : handleRegister} className="space-y-4">
              {view === 'register' && (
                <>
                  <div>
                    <Label htmlFor="firstName" className="text-white">Nombre</Label>
                    <Input
                      id="firstName"
                      type="text"
                      value={firstName}
                      onChange={(e) => setFirstName(e.target.value)}
                      required
                      className="bg-white/10 border-white/20 text-white placeholder:text-white/60"
                      placeholder="Tu nombre"
                    />
                  </div>
                  <div>
                    <Label htmlFor="lastName" className="text-white">Apellido</Label>
                    <Input
                      id="lastName"
                      type="text"
                      value={lastName}
                      onChange={(e) => setLastName(e.target.value)}
                      required
                      className="bg-white/10 border-white/20 text-white placeholder:text-white/60"
                      placeholder="Tu apellido"
                    />
                  </div>
                </>
              )}
              <div>
                <Label htmlFor="email" className="text-white">Email</Label>
                <Input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="bg-white/10 border-white/20 text-white placeholder:text-white/60"
                  placeholder="tu@email.com"
                />
              </div>
              <div>
                <Label htmlFor="password" className="text-white">Contraseña</Label>
                <Input
                  id="password"
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  className="bg-white/10 border-white/20 text-white placeholder:text-white/60"
                  placeholder="••••••••"
                />
              </div>
              <Button type="submit" className="w-full">
                {view === 'login' ? 'Iniciar Sesión' : 'Registrarse'}
              </Button>
            </form>
          </CardContent>
        </Card>
      </div>
    )
  }

  const renderDashboard = () => (
    <div className="space-y-6">
      <div className="text-center">
        <h1 className="text-3xl font-bold text-gray-900">
          Bienvenido, {currentUser.first_name}
        </h1>
        <p className="text-gray-600 capitalize">Rol: {currentUser.role}</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {(currentUser.role === 'liner' || currentUser.role === 'closer') && (
          <>
            <Card className="cursor-pointer hover:shadow-lg transition-shadow">
              <CardContent className="p-6 text-center">
                <div className="mb-4">
                  <UserCheck className="h-12 w-12 text-primary mx-auto" />
                </div>
                <h3 className="text-lg font-semibold mb-2">
                  {currentUser.role === 'liner' ? 'Calificar Closer' : 'Calificar Liner'}
                </h3>
                <p className="text-gray-600 mb-4 text-sm">
                  Evalúa el desempeño de tu compañero
                </p>
                <Button 
                  onClick={() => setView(currentUser.role === 'liner' ? 'rate-closer' : 'rate-liner')}
                  className="w-full"
                >
                  Comenzar Evaluación
                </Button>
              </CardContent>
            </Card>

            <Card className="cursor-pointer hover:shadow-lg transition-shadow">
              <CardContent className="p-6 text-center">
                <div className="mb-4">
                  <Star className="h-12 w-12 text-yellow-500 mx-auto" />
                </div>
                <h3 className="text-lg font-semibold mb-2">Mis Calificaciones</h3>
                <p className="text-gray-600 mb-4 text-sm">
                  Ver evaluaciones recibidas
                </p>
                <Button 
                  onClick={() => setView('my-ratings')}
                  variant="outline"
                  className="w-full"
                >
                  Ver Calificaciones ({myRatings.length})
                </Button>
              </CardContent>
            </Card>
          </>
        )}

        {currentUser.role === 'liner' && (
          <Card className="cursor-pointer hover:shadow-lg transition-shadow">
            <CardContent className="p-6 text-center">
              <div className="mb-4">
                <ClipboardList className="h-12 w-12 text-blue-500 mx-auto" />
              </div>
              <h3 className="text-lg font-semibold mb-2">Follow-up de Ventas</h3>
              <p className="text-gray-600 mb-4 text-sm">
                Registrar información de ventas
              </p>
              <Button 
                onClick={() => setView('follow-up')}
                variant="outline"
                className="w-full"
              >
                Nuevo Follow-up
              </Button>
            </CardContent>
          </Card>
        )}

        {currentUser.role === 'manager' && (
          <Card className="cursor-pointer hover:shadow-lg transition-shadow">
            <CardContent className="p-6 text-center">
              <div className="mb-4">
                <BarChart3 className="h-12 w-12 text-green-500 mx-auto" />
              </div>
              <h3 className="text-lg font-semibold mb-2">Reportes</h3>
              <p className="text-gray-600 mb-4 text-sm">
                Ver estadísticas del equipo
              </p>
              <Button 
                variant="outline"
                className="w-full"
                disabled
              >
                Próximamente
              </Button>
            </CardContent>
          </Card>
        )}
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <TrendingUp className="h-5 w-5" />
            Resumen Personal
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="text-center">
              <div className="text-2xl font-bold text-primary">{ratings.filter(r => r.evaluator_id === currentUser.id).length}</div>
              <div className="text-sm text-gray-600">Calificaciones Dadas</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-yellow-500">{myRatings.length}</div>
              <div className="text-sm text-gray-600">Calificaciones Recibidas</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-green-500">
                {myRatings.length > 0 
                  ? (myRatings.reduce((sum, rating) => {
                      const ratings = rating.ratings_json || {}
                      const values = Object.values(ratings).filter(v => typeof v === 'number')
                      return sum + (values.length > 0 ? values.reduce((a, b) => a + b, 0) / values.length : 0)
                    }, 0) / myRatings.length).toFixed(1)
                  : '0.0'
                }
              </div>
              <div className="text-sm text-gray-600">Promedio</div>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  )

  const renderRatingForm = () => {
    const categories = getRatingCategories()
    const filteredUsers = getFilteredUsers()
    const isRatingCloser = view === 'rate-closer'

    return (
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <h2 className="text-2xl font-bold">
            {isRatingCloser ? 'Calificar Closer' : 'Calificar Liner'}
          </h2>
          <Button onClick={() => setView('dashboard')} variant="outline">
            Volver
          </Button>
        </div>

        <Card>
          <CardHeader>
            <CardTitle>Seleccionar Usuario</CardTitle>
          </CardHeader>
          <CardContent>
            <Select value={selectedUserId} onValueChange={setSelectedUserId}>
              <SelectTrigger>
                <SelectValue placeholder="Selecciona un usuario para calificar" />
              </SelectTrigger>
              <SelectContent>
                {filteredUsers.map(user => (
                  <SelectItem key={user.id} value={user.id}>
                    {user.first_name} {user.last_name} ({user.role})
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </CardContent>
        </Card>

        {selectedUserId && (
          <Card>
            <CardHeader>
              <CardTitle>Criterios de Evaluación</CardTitle>
              <p className="text-sm text-gray-600">
                Califica cada criterio del 1 al 5 estrellas
              </p>
            </CardHeader>
            <CardContent className="space-y-4">
              {categories.map(category => (
                <RatingCard
                  key={category}
                  title={category}
                  rating={ratingData[category] || 0}
                  onRatingChange={(value) => handleRatingChange(category, value)}
                />
              ))}

              <div className="space-y-2">
                <Label htmlFor="comments">Comentarios (Opcional)</Label>
                <Textarea
                  id="comments"
                  value={comments}
                  onChange={(e) => setComments(e.target.value)}
                  placeholder="Escribe comentarios adicionales aquí..."
                  className="min-h-[100px]"
                />
              </div>

              <Button onClick={submitRating} className="w-full" size="lg">
                Enviar Calificación
              </Button>
            </CardContent>
          </Card>
        )}
      </div>
    )
  }

  const renderMyRatings = () => (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold">Mis Calificaciones</h2>
        <Button onClick={() => setView('dashboard')} variant="outline">
          Volver
        </Button>
      </div>

      {myRatings.length === 0 ? (
        <Card>
          <CardContent className="p-6 text-center">
            <Star className="h-12 w-12 text-gray-400 mx-auto mb-4" />
            <p className="text-gray-600">No tienes calificaciones aún</p>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-4">
          {myRatings.map(rating => {
            const evaluator = users.find(u => u.id === rating.evaluator_id)
            const ratingsObj = rating.ratings_json || {}
            const avgRating = Object.values(ratingsObj).length > 0 
              ? Object.values(ratingsObj).reduce((a, b) => a + b, 0) / Object.values(ratingsObj).length
              : 0

            return (
              <Card key={rating.id}>
                <CardHeader>
                  <div className="flex items-center justify-between">
                    <CardTitle className="text-lg">
                      Evaluado por: {evaluator?.first_name} {evaluator?.last_name}
                    </CardTitle>
                    <div className="flex items-center gap-2">
                      <StarRating rating={Math.round(avgRating)} readonly />
                      <span className="text-sm text-gray-600">
                        {avgRating.toFixed(1)}/5
                      </span>
                    </div>
                  </div>
                  <p className="text-sm text-gray-600">
                    Fecha: {new Date(rating.date).toLocaleDateString()}
                  </p>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    {Object.entries(ratingsObj).map(([category, score]) => (
                      <div key={category} className="flex items-center justify-between">
                        <span className="text-sm">{category}</span>
                        <StarRating rating={score} readonly size={16} />
                      </div>
                    ))}
                    {rating.comments && (
                      <div className="mt-4 p-3 bg-gray-50 rounded-lg">
                        <p className="text-sm font-medium text-gray-700">Comentarios:</p>
                        <p className="text-sm text-gray-600 mt-1">{rating.comments}</p>
                      </div>
                    )}
                  </div>
                </CardContent>
              </Card>
            )
          })}
        </div>
      )}
    </div>
  )

  const renderFollowUp = () => (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold">Follow-up de Ventas</h2>
        <Button onClick={() => setView('dashboard')} variant="outline">
          Volver
        </Button>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Información de Venta</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <Label>Tipo de Membresía</Label>
              <Select 
                value={followUpData.tipoMembresia} 
                onValueChange={(value) => setFollowUpData(prev => ({...prev, tipoMembresia: value}))}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Seleccionar..." />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="perla">Perla</SelectItem>
                  <SelectItem value="plata">Plata</SelectItem>
                  <SelectItem value="oro">Oro</SelectItem>
                  <SelectItem value="platino">Platino</SelectItem>
                  <SelectItem value="diamante">Diamante</SelectItem>
                  <SelectItem value="blue-diamond">Blue Diamond</SelectItem>
                  <SelectItem value="black">Black</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div>
              <Label>Número de Contrato</Label>
              <Input
                value={followUpData.numeroContrato}
                onChange={(e) => setFollowUpData(prev => ({...prev, numeroContrato: e.target.value}))}
                placeholder="Número de contrato"
              />
            </div>

            <div>
              <Label>Nombre de Socios</Label>
              <Input
                value={followUpData.nombreSocios}
                onChange={(e) => setFollowUpData(prev => ({...prev, nombreSocios: e.target.value}))}
                placeholder="Nombres completos"
              />
            </div>

            <div>
              <Label>Precio</Label>
              <Input
                type="number"
                value={followUpData.precio}
                onChange={(e) => setFollowUpData(prev => ({...prev, precio: e.target.value}))}
                placeholder="0.00"
              />
            </div>

            <div>
              <Label>Estatus</Label>
              <Select 
                value={followUpData.estatus} 
                onValueChange={(value) => setFollowUpData(prev => ({...prev, estatus: value}))}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Seleccionar..." />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="pendiente">Pendiente</SelectItem>
                  <SelectItem value="procesando">Procesando</SelectItem>
                  <SelectItem value="completado">Completado</SelectItem>
                  <SelectItem value="cancelado">Cancelado</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <div className="flex items-center space-x-2">
                <input
                  type="checkbox"
                  id="hayMoveIn"
                  checked={followUpData.hayMoveIn}
                  onChange={(e) => setFollowUpData(prev => ({...prev, hayMoveIn: e.target.checked}))}
                  className="rounded border-gray-300"
                />
                <Label htmlFor="hayMoveIn">¿Hay Move-in?</Label>
              </div>
              
              {followUpData.hayMoveIn && (
                <div>
                  <Label>Fecha de Move-in</Label>
                  <Input
                    type="date"
                    value={followUpData.fechaMoveIn}
                    onChange={(e) => setFollowUpData(prev => ({...prev, fechaMoveIn: e.target.value}))}
                  />
                </div>
              )}
            </div>
          </div>

          <Button onClick={submitFollowUp} className="w-full" size="lg">
            Guardar Follow-up
          </Button>
        </CardContent>
      </Card>
    </div>
  )

  return (
    <div className="min-h-screen bg-gray-50">
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <Award className="h-8 w-8 text-primary mr-3" />
              <h1 className="text-xl font-bold text-gray-900">Club Vacacional</h1>
            </div>
            <div className="flex items-center space-x-4">
              <span className="text-sm text-gray-600">
                {currentUser.first_name} {currentUser.last_name}
              </span>
              <Button onClick={handleLogout} variant="outline" size="sm">
                <LogOut className="h-4 w-4 mr-2" />
                Salir
              </Button>
            </div>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {view === 'dashboard' && renderDashboard()}
        {(view === 'rate-closer' || view === 'rate-liner') && renderRatingForm()}
        {view === 'my-ratings' && renderMyRatings()}
        {view === 'follow-up' && renderFollowUp()}
      </main>
    </div>
  )
}