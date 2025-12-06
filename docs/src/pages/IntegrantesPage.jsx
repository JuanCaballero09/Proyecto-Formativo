import { useIsMobile } from '../hooks/useIsMobile';

function IntegrantesPage() {
  const isMobile = useIsMobile();

  const integrantes = [
    {
      nombre: "Juan Esteban",
      apellido: "Caballero Goenaga",
      rol: "Full Stack Developer",
      github: "https://github.com/JuanCaballero09",
      email: "juanes0921200@gmail.com"
    },
    {
      nombre: "Santiago David",
      apellido: "Zambrano Izaquita",
      rol: "Backend Developer",
      github: "https://github.com/San5472",
      email: "santiagozambrano751@gmail.com"
    },
    {
      nombre: "Andrw Stiven",
      apellido: "Barrera Poveda",
      rol: "Frontend Developer",
      github: "https://github.com/andrw790",
      email: "andrwbarrera79@gmail.com"
    },
    {
      nombre: "Wilber Eliécer",
      apellido: "Robles Mercado",
      rol: "Mobile Developer",
      github: "https://github.com/Tribalsoft",
      email: "wilrm8sena@gmail.com"
    },
    {
      nombre: "Miguel Junior",
      apellido: "Sarabia Soto",
      rol: "UI/UX Designer",
      github: "https://github.com/MiguelSarabiaSoto",
      email: "Miguelsarabia08@hotmail.com"
    }
  ];

  const handleEmailClick = (email) => {
    if (isMobile) {
      window.location.href = `mailto:${email}`;
    } else {
      window.open(`https://mail.google.com/mail/?view=cm&to=${email}`, '_blank');
    }
  };

  return (
    <div className="page-container">
      <h1 className="page-title">Equipo</h1>
      <p className="page-subtitle">Desarrolladores del proyecto Bitevia</p>
      
      <div className="team-grid">
        {integrantes.map((integrante, index) => (
          <div className="team-card" key={index}>
            <div className="team-avatar">
              <i className="fa-solid fa-user"></i>
            </div>
            <h3>{integrante.nombre}</h3>
            <h4>{integrante.apellido}</h4>
            <span className="team-role">{integrante.rol}</span>
            <div className="team-social">
              <a 
                href={integrante.github} 
                target="_blank" 
                rel="noopener noreferrer"
                aria-label={`GitHub de ${integrante.nombre}`}
              >
                <i className="fa-brands fa-github"></i>
              </a>
              <button
                onClick={() => handleEmailClick(integrante.email)}
                aria-label={`Enviar correo a ${integrante.nombre}`}
                className="btn-icon"
              >
                <i className="fa-solid fa-envelope"></i>
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default IntegrantesPage;
