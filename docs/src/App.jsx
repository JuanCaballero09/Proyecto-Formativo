import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { ThemeProvider } from './context/ThemeContext'
import './App.css'
import ErrorBoundary from './components/ErrorBoundary'
import Navbar from './components/Navbar'
import ScrollToTop from './components/ScrollToTop'
import HomePage from './pages/HomePage'
import DocumentosPage from './pages/DocumentosPage'
import IntegrantesPage from './pages/IntegrantesPage'
import RecursosPage from './pages/RecursosPage'
import ManualUsuarioPage from './pages/ManualUsuarioPage'
import ManualTecnicoPage from './pages/ManualTecnicoPage'

function App() {
  return (
    <ErrorBoundary>
      <ThemeProvider>
        <Router>
          <div className="app">
            <Navbar />
            <main className="main-content">
              <Routes>
                <Route path="/" element={<HomePage />} />
                <Route path="/documentos" element={<DocumentosPage />} />
                <Route path="/equipo" element={<IntegrantesPage />} />
                <Route path="/tecnologias" element={<RecursosPage />} />
                <Route path="/manual-usuario" element={<ManualUsuarioPage />} />
                <Route path="/manual-tecnico" element={<ManualTecnicoPage />} />
              </Routes>
            </main>
            <ScrollToTop />
          </div>
        </Router>
      </ThemeProvider>
    </ErrorBoundary>
  )
}

export default App
