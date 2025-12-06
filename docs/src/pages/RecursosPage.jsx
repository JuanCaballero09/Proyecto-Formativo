function RecursosPage() {
  const tecnologias = [
    {
      nombre: "Ruby on Rails",
      tipo: "Backend Framework",
      img: "/img/Ruby_logo.png",
      descripcion: "Framework MVC para desarrollo web rápido y eficiente.",
      url: "https://rubyonrails.org/"
    },
    {
      nombre: "Flutter",
      tipo: "Mobile Framework",
      img: "/img/flutter_logo.png",
      descripcion: "Framework multiplataforma para apps nativas iOS y Android.",
      url: "https://flutter.dev/"
    },
    {
      nombre: "PostgreSQL",
      tipo: "Base de Datos",
      descripcion: "Sistema de base de datos relacional robusto y escalable.",
      icon: "fa-solid fa-database"
    },
    {
      nombre: "JavaScript",
      tipo: "Lenguaje",
      img: "/img/javascript_logo.webp",
      descripcion: "Lenguaje de programación para interactividad web.",
      url: "https://developer.mozilla.org/en-US/docs/Web/JavaScript"
    },
    {
      nombre: "Bootstrap",
      tipo: "CSS Framework",
      img: "/img/bootstrap_logo.png",
      descripcion: "Framework CSS para diseño responsive.",
      url: "https://getbootstrap.com/"
    },
    {
      nombre: "Git",
      tipo: "Control de Versiones",
      descripcion: "Sistema de control de versiones distribuido.",
      icon: "fa-brands fa-git-alt"
    }
  ];

  return (
    <div className="page-container">
      <h1 className="page-title">Tecnologías</h1>
      <p className="page-subtitle">Stack tecnológico del proyecto</p>
      
      <div className="tech-grid">
        {tecnologias.map((tech, index) => (
          <div className="tech-card" key={index}>
            <div className="tech-icon">
              {tech.img ? (
                <img 
                  src={tech.img} 
                  alt={tech.nombre}
                  loading="lazy"
                  onError={(e) => {
                    e.target.style.display = 'none';
                  }}
                />
              ) : (
                <i className={tech.icon}></i>
              )}
            </div>
            <span className="tech-type">{tech.tipo}</span>
            <h3>{tech.nombre}</h3>
            <p>{tech.descripcion}</p>
            {tech.url && (
              <a 
                href={tech.url} 
                target="_blank" 
                rel="noopener noreferrer"
                className="btn-link"
              >
                Ver documentación <i className="fa-solid fa-arrow-right"></i>
              </a>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}

export default RecursosPage;
