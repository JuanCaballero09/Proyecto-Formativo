function Recursos() {
  const lenguajes = [
    {
      nombre: "Ruby",
      img: "/img/Ruby_logo.png",
      descripcion: "Este proyecto está desarrollado a través de Ruby on Rails, utilizado como backend.",
      url: "https://www.ruby-lang.org/es/"
    },
    {
      nombre: "Dart",
      img: "/img/Dart_logo.png",
      descripcion: "El proyecto movil esta basado en el lenguaje dart con el framework de flutter.",
      url: "https://dart.dev/"
    },
    {
      nombre: "Html",
      img: "/img/html-logo.webp",
      descripcion: "Usado para darle forma al frontend de la pagina web de ruby.",
      url: "https://developer.mozilla.org/es/docs/Web/HTML"
    },
    {
      nombre: "CSS",
      img: "/img/css_logo.png",
      descripcion: "Css es una hoja de estilo en cascada usada para darle diseño a las paginnas web.",
      url: "https://developer.mozilla.org/en-US/docs/Web/CSS"
    },
    {
      nombre: "JavaScript",
      img: "/img/javascript_logo.webp",
      descripcion: "JavaScript es el lenguaje de programacion de las paginas web usado mayormente para funciones especificas y hace que las webs sean mas dinamicas.",
      url: "https://developer.mozilla.org/en-US/docs/Web/JavaScript"
    }
  ];

  const frameworks = [
    {
      nombre: "Rails",
      img: "/img/rails_logo.png",
      descripcion: "FrameWork usado para crear paginas web para ruby.",
      url: "https://rubyonrails.org/"
    },
    {
      nombre: "Flutter",
      img: "/img/flutter_logo.png",
      descripcion: "FrameWork usado para crear applicaciones moviles para Android y iOS.",
      url: "https://flutter.dev/"
    },
    {
      nombre: "Bootstrap",
      img: "/img/bootstrap_logo.png",
      descripcion: "Bootstrap Es un FrameWorkusado para darle forma a una pagina web de manera mas rapida.",
      url: "https://getbootstrap.com/"
    }
  ];

  return (
    <>
      <span className="lines"></span>
      <br />
      <h1 className="h1">Recursos</h1>
      <div id="recursos">
        <h2 style={{ margin: '20px' }}>Lenguajes de Programación:</h2>
        <div className="cartas-recursos">
          {lenguajes.map((lenguaje, index) => (
            <div className="carta-recursos" key={index}>
              <img 
                src={lenguaje.img} 
                alt={lenguaje.nombre}
                loading="lazy"
                onError={(e) => {
                  e.target.style.display = 'none';
                  e.target.nextSibling.textContent = `📄 ${lenguaje.nombre}`;
                }}
              />
              <h2>{lenguaje.nombre}</h2>
              <p>{lenguaje.descripcion}</p>
              <a href={lenguaje.url} target="_blank" rel="noopener noreferrer" className="btn btn-primary">
                Leer documentación
              </a>
            </div>
          ))}
        </div>

        <h2 style={{ margin: '20px' }}>FrameWorks:</h2>
        <div className="cartas-recursos">
          {frameworks.map((framework, index) => (
            <div className="carta-recursos" key={index}>
              <img 
                src={framework.img} 
                alt={framework.nombre}
                loading="lazy"
                onError={(e) => {
                  e.target.style.display = 'none';
                  e.target.nextSibling.textContent = `📦 ${framework.nombre}`;
                }}
              />
              <h2>{framework.nombre}</h2>
              <p>{framework.descripcion}</p>
              <a href={framework.url} target="_blank" rel="noopener noreferrer" className="btn btn-primary">
                Leer documentación
              </a>
            </div>
          ))}
        </div>
      </div>
      <br />
    </>
  );
}

export default Recursos;
