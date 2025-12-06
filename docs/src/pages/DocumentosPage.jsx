import { documentos, getDocumentUrl } from '../config/documentos';

function DocumentosPage() {
  return (
    <div className="page-container">
      <h1 className="page-title">Documentación</h1>
      <p className="page-subtitle">Documentos técnicos principales del proyecto</p>
      
      <div className="docs-grid">
        {documentos.map((doc, index) => (
          <div className="doc-card" key={index}>
            <div className="doc-header">
              <span className="doc-category">{doc.categoria}</span>
              <i className="fa-solid fa-file-pdf"></i>
            </div>
            <h3>{doc.titulo}</h3>
            <p>{doc.descripcion}</p>
            <div className="doc-actions">
              <a 
                href={getDocumentUrl(doc.archivo)} 
                className="btn-secondary" 
                target="_blank" 
                rel="noopener noreferrer"
              >
                <i className="fa-solid fa-eye"></i> Ver
              </a>
              <a 
                href={getDocumentUrl(doc.archivo)} 
                className="btn-primary"
                download
              >
                <i className="fa-solid fa-download"></i> Descargar
              </a>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default DocumentosPage;
