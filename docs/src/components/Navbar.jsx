import { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { useTheme } from '../context/ThemeContext';

function Navbar() {
  const [menuOpen, setMenuOpen] = useState(false);
  const location = useLocation();
  const { isDark, toggleTheme } = useTheme();

  const closeMenu = () => setMenuOpen(false);

  const isActive = (path) => location.pathname === path;

  return (
    <>
      <nav className="navbar">
        <Link to="/" className="navbar-brand" onClick={closeMenu}>
          <img src="/img/icons/LogoLogo.svg" alt="Bitevia" className="navbar-logo" />
          <span>Bitevia</span>
        </Link>

        <div className={`navbar-menu ${menuOpen ? 'active' : ''}`}>
          <Link 
            to="/" 
            className={`nav-link ${isActive('/') ? 'active' : ''}`}
            onClick={closeMenu}
          >
            <i className="fa-solid fa-house"></i>
            <span>Inicio</span>
          </Link>
          <Link 
            to="/documentos" 
            className={`nav-link ${isActive('/documentos') ? 'active' : ''}`}
            onClick={closeMenu}
          >
            <i className="fa-solid fa-book"></i>
            <span>Documentos</span>
          </Link>
          <Link 
            to="/equipo" 
            className={`nav-link ${isActive('/equipo') ? 'active' : ''}`}
            onClick={closeMenu}
          >
            <i className="fa-solid fa-users"></i>
            <span>Equipo</span>
          </Link>
          <Link 
            to="/tecnologias" 
            className={`nav-link ${isActive('/tecnologias') ? 'active' : ''}`}
            onClick={closeMenu}
          >
            <i className="fa-solid fa-code"></i>
            <span>Tecnologías</span>
          </Link>
          <Link 
            to="/manual-usuario" 
            className={`nav-link ${isActive('/manual-usuario') ? 'active' : ''}`}
            onClick={closeMenu}
          >
            <i className="fa-solid fa-user-graduate"></i>
            <span>Manual Usuario</span>
          </Link>
          <Link 
            to="/manual-tecnico" 
            className={`nav-link ${isActive('/manual-tecnico') ? 'active' : ''}`}
            onClick={closeMenu}
          >
            <i className="fa-solid fa-cogs"></i>
            <span>Manual Técnico</span>
          </Link>
        </div>

        <div className="navbar-actions">
          <button 
            className="theme-toggle" 
            onClick={toggleTheme}
            aria-label="Cambiar tema"
          >
            <i className={isDark ? 'fa-solid fa-sun' : 'fa-solid fa-moon'}></i>
          </button>
          <button 
            className="menu-toggle"
            onClick={() => setMenuOpen(!menuOpen)}
            aria-label="Menú"
          >
            <i className={menuOpen ? 'fa-solid fa-times' : 'fa-solid fa-bars'}></i>
          </button>
        </div>
      </nav>
    </>
  );
}

export default Navbar;
