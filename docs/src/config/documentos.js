// Configuración de rutas de documentos
export const DOCUMENTS_PATH = '/documents';

// Solo documentos importantes
export const documentos = [
  {
    titulo: "Manual de Usuario",
    descripcion: "Guía completa para el uso del sistema Bitevia.",
    archivo: "Manual de usuario Bitevia software.pdf",
    categoria: "Documentación"
  },
  {
    titulo: "Manual Técnico",
    descripcion: "Documentación técnica completa del sistema.",
    archivo: "Manual técnico Bitevia software.pdf",
    categoria: "Documentación"
  },
  {
    titulo: "Diagrama de Clases",
    descripcion: "Estructura completa del sistema mostrando clases, atributos, métodos y relaciones.",
    archivo: "Diagrama_Clase.pdf",
    categoria: "Diseño"
  },
  {
    titulo: "Diagrama Entidad-Relación",
    descripcion: "Modelo de base de datos con entidades, atributos y relaciones del sistema.",
    archivo: "Diagrama_Entidad_Relacion.pdf",
    categoria: "Base de Datos"
  },
  {
    titulo: "Mockup Software",
    descripcion: "Diseño completo de la interfaz de usuario del sistema.",
    archivo: "Mockup_software.pdf",
    categoria: "Diseño"
  },
  {
    titulo: "Casos de Uso - Cliente",
    descripcion: "Diagrama de interacciones del cliente con el sistema.",
    archivo: "DiagramaCasoUsoClientes.pdf",
    categoria: "Análisis"
  }
];

// Helper para obtener la URL completa del documento
export const getDocumentUrl = (archivo) => `${DOCUMENTS_PATH}/${archivo}`;
