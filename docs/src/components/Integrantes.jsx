import { useIsMobile } from '../hooks/useIsMobile';

function Integrantes() {
  const isMobile = useIsMobile();

  const integrantes = [
    {
      nombre: "Juan Esteban",
      apellido: "Caballero Goenaga",
      github: "https://github.com/JuanCaballero09",
      email: "juanes0921200@gmail.com"
    },
    {
      nombre: "Santiago David",
      apellido: "Zambrano Izaquita",
      github: "https://github.com/San5472",
      email: "santiagozambrano751@gmail.com"
    },
    {
      nombre: "Andrw Stiven",
      apellido: "Barrera Poveda",
      github: "https://github.com/andrw790",
      email: "andrwbarrera79@gmail.com"
    },
    {
      nombre: "Wilber Eliécer",
      apellido: "Robles Mercado",
      github: "https://github.com/Tribalsoft",
      email: "wilrm8sena@gmail.com"
    },
    {
      nombre: "Miguel Junior",
      apellido: "Sarabia Soto",
      github: "https://github.com/MiguelSarabiaSoto",
      email: "Miguelsarabia08@hotmail.com"
    }
  ];

  const handleEmailClick = (email) => {
    if (isMobile) {
      // En móvil, usar mailto
      window.location.href = `mailto:${email}`;
    } else {
      // En desktop, abrir Gmail
      window.open(`https://mail.google.com/mail/?view=cm&to=${email}`, '_blank');
    }
  };

  return (
    <>
      <br />
      <span className="lines"></span>
      <br />
      <h1 className="h1">Integrantes</h1>
      <div id="cont-inte">
        {integrantes.map((integrante, index) => (
          <div className="inte" key={index}>
            <h2 id="nombre">{integrante.nombre}</h2>
            <h2 id="apellido">{integrante.apellido}</h2>
            <div id="redes">
              <a 
                href={integrante.github} 
                target="_blank" 
                rel="noopener noreferrer"
                aria-label={`GitHub de ${integrante.nombre}`}
              >
                <i className="fa-brands fa-github"></i>
              </a>
              <a 
                href="#"
                onClick={(e) => {
                  e.preventDefault();
                  handleEmailClick(integrante.email);
                }}
                aria-label={`Enviar correo a ${integrante.nombre}`}
              >
                <i className="fa-solid fa-envelope"></i>
              </a>
            </div>
          </div>
        ))}
      </div>
      <br />
    </>
  );
}

export default Integrantes;
