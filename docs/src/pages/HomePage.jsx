function HomePage() {
  return (
    <div className="page-container">
      <section className="hero">
        <div className="hero-content">
          <h1 className="hero-title">Bitevia Software</h1>
          <p className="hero-subtitle">
            Sistema de pedidos en línea y entregas a domicilio
          </p>
          <p className="hero-description">
            Documentación técnica completa del proyecto. Encuentra diagramas, mockups,
            casos de uso y recursos sobre las tecnologías utilizadas.
          </p>
        </div>
      </section>

      <section className="features">
        <div className="feature-card">
          <i className="fa-solid fa-code"></i>
          <h3>Tecnologías Modernas</h3>
          <p>Ruby on Rails, Flutter y más</p>
        </div>
        <div className="feature-card">
          <i className="fa-solid fa-mobile-screen"></i>
          <h3>Multi-plataforma</h3>
          <p>Web y aplicaciones móviles</p>
        </div>
        <div className="feature-card">
          <i className="fa-solid fa-users"></i>
          <h3>Equipo Dedicado</h3>
          <p>5 desarrolladores especializados</p>
        </div>
      </section>
    </div>
  );
}

export default HomePage;
