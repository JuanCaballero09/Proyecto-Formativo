import { documentos, getDocumentUrl } from '../config/documentos';

function Documentos() {
  return (
    <>
      <span className="lines"></span>
      <br />
      <h1 className="h1" id="docs">Documentos</h1>
      <div id="documentos">
        {documentos.map((doc, index) => (
          <div className="contenedor" key={index}>
            <h2>{doc.titulo}</h2>
            <p>{doc.descripcion}</p>
            <a 
              href={getDocumentUrl(doc.archivo)} 
              className="btn-ver" 
              target="_blank" 
              rel="noopener noreferrer"
            >
              Ver
            </a>
            <a 
              href={getDocumentUrl(doc.archivo)} 
              download
            >
              Descargar
            </a>
          </div>
        ))}
      </div>
      <br />
    </>
  );
}

export default Documentos;
