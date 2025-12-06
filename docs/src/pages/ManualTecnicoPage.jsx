import React from 'react';

const ManualTecnicoPage = () => {
  return (
    <div className="manual-page">
      <div className="manual-container">
        
        {/* Header */}
        <header className="manual-header">
          <h1>Manual Técnico</h1>
          <p className="manual-subtitle">Documentación técnica del sistema Bitevia</p>
        </header>

        {/* Introducción */}
        <section className="manual-section">
          <p className="intro-text">
            Este documento está dirigido al equipo de soporte técnico y desarrollo. 
            Detalla la estructura del sistema, arquitectura, base de datos y componentes 
            desarrollados para el software Bitevia.
          </p>
        </section>

        {/* Alcance */}
        <section className="manual-section">
          <h2>Alcance del Sistema</h2>
          <p>
            Software desarrollado para sistematizar los procesos de ventas en el local de 
            comidas rápidas "La Terraza del Pri", ubicado en Calle 56 #34-6, barrio Ciudadela 
            Metropolitana, Soledad, Atlántico.
          </p>
        </section>

        {/* Arquitectura */}
        <section className="manual-section">
          <h2>Arquitectura del Sistema</h2>

          <div className="function-item">
            <h3>Frontend (Cliente)</h3>
            <ul className="simple-list">
              <li>Accesibilidad universal vía navegadores web</li>
              <li>Catálogo de productos organizado por categorías</li>
              <li>Sistema de carrito de compras dinámico</li>
              <li>Soporte multilingüe (Español/Inglés)</li>
              <li>Interfaz responsiva adaptada a móviles y escritorio</li>
            </ul>
          </div>

          <div className="function-item">
            <h3>Backend (Servidor)</h3>
            <ul className="simple-list">
              <li>Procesamiento de pedidos con integridad transaccional</li>
              <li>Gestión de cuentas y autenticación de usuarios</li>
              <li>Persistencia de datos en base de datos relacional</li>
              <li>API RESTful para comunicación cliente-servidor</li>
              <li>Sistema de seguridad y validación de datos</li>
            </ul>
          </div>

          <div className="function-item">
            <h3>Panel de Administración</h3>
            <ul className="simple-list">
              <li>Análisis y reportes de ventas en tiempo real</li>
              <li>Gestión completa de inventario y menú</li>
              <li>Administración de ingredientes y categorías</li>
              <li>Modificación de banners promocionales</li>
              <li>Estadísticas y métricas del negocio</li>
            </ul>
          </div>

          <div className="function-item">
            <h3>Interfaz de Cocina</h3>
            <ul className="simple-list">
              <li>Visualización de pedidos en tiempo real</li>
              <li>Estados: En Preparación → Terminado → En Tránsito → Entregado</li>
              <li>Notificaciones automáticas de nuevos pedidos</li>
              <li>Panel optimizado para flujo de trabajo en cocina</li>
            </ul>
          </div>
        </section>

        {/* Stack Tecnológico */}
        <section className="manual-section">
          <h2>Stack Tecnológico</h2>

          <div className="tech-stack-simple">
            <div className="tech-category">
              <h3>Frontend</h3>
              <p>HTML5, CSS3, JavaScript ES6+</p>
              <p>Framework: React.js</p>
              <p>Diseño Responsivo y Mobile-First</p>
            </div>

            <div className="tech-category">
              <h3>Backend</h3>
              <p>Node.js con Express.js</p>
              <p>API RESTful</p>
              <p>Autenticación JWT</p>
            </div>

            <div className="tech-category">
              <h3>Base de Datos</h3>
              <p>MySQL / PostgreSQL</p>
              <p>Modelo Relacional Normalizado</p>
              <p>Diccionario de Datos Documentado</p>
            </div>

            <div className="tech-category">
              <h3>Aplicación Móvil</h3>
              <p>React Native</p>
              <p>Expo Framework</p>
              <p>Compatible iOS y Android</p>
            </div>
          </div>
        </section>

        {/* Diagramas */}
        <section className="manual-section">
          <h2>Diagramas del Sistema</h2>
          <p>El manual técnico completo incluye:</p>
          <ul className="simple-list">
            <li><strong>Diagrama de Clases:</strong> Modelo orientado a objetos</li>
            <li><strong>Diagrama Entidad-Relación:</strong> Estructura completa de la base de datos</li>
            <li><strong>Mapa de Navegación:</strong> Flujo de usuario en el sistema</li>
            <li><strong>Casos de Uso:</strong> Funcionalidades por rol (Admin, Chef, Cliente)</li>
            <li><strong>Modelo Relacional:</strong> Tablas, campos y relaciones</li>
          </ul>
        </section>

        {/* Módulos del Sistema */}
        <section className="manual-section">
          <h2>Módulos del Sistema</h2>

          <div className="module-list">
            <div className="module-item">
              <h4>Gestión de Grupos (Categorías)</h4>
              <p>CRUD completo: Crear, editar, activar/desactivar y eliminar categorías de productos</p>
            </div>

            <div className="module-item">
              <h4>Gestión de Productos</h4>
              <p>Administración del menú: precios, disponibilidad, ingredientes, imágenes</p>
            </div>

            <div className="module-item">
              <h4>Gestión de Ingredientes</h4>
              <p>Control de inventario de ingredientes con alertas de stock bajo</p>
            </div>

            <div className="module-item">
              <h4>Gestión de Órdenes</h4>
              <p>Procesamiento, seguimiento y actualización de estados de pedidos</p>
            </div>

            <div className="module-item">
              <h4>Gestión de Usuarios</h4>
              <p>Administración de cuentas, roles (Admin, Chef, Cliente) y permisos</p>
            </div>

            <div className="module-item">
              <h4>Gestión de Cupones</h4>
              <p>Sistema de descuentos, promociones y códigos de cupón</p>
            </div>

            <div className="module-item">
              <h4>Gestión de Combos</h4>
              <p>Creación de ofertas especiales y combos de productos</p>
            </div>

            <div className="module-item">
              <h4>Estadísticas y Reportes</h4>
              <p>Análisis de ventas, productos más vendidos, gráficas de crecimiento</p>
            </div>
          </div>
        </section>

        {/* Base de Datos */}
        <section className="manual-section">
          <h2>Modelo de Base de Datos</h2>
          <p>
            El sistema utiliza un modelo relacional normalizado que incluye las siguientes 
            entidades principales:
          </p>
          <ul className="simple-list">
            <li><strong>Usuarios:</strong> Datos de autenticación y perfil</li>
            <li><strong>Productos:</strong> Información del menú</li>
            <li><strong>Grupos:</strong> Categorías de productos</li>
            <li><strong>Ingredientes:</strong> Componentes de cada producto</li>
            <li><strong>Órdenes:</strong> Pedidos realizados</li>
            <li><strong>Detalles de Orden:</strong> Items específicos de cada pedido</li>
            <li><strong>Cupones:</strong> Descuentos y promociones</li>
            <li><strong>Banners:</strong> Contenido promocional</li>
          </ul>
          <p className="note-text">
            El diagrama completo de entidad-relación y el diccionario de datos están 
            disponibles en el PDF del manual técnico.
          </p>
        </section>

        {/* Estructura de Carpetas */}
        <section className="manual-section">
          <h2>Estructura del Proyecto</h2>
          <p>
            El código fuente está organizado siguiendo las mejores prácticas de desarrollo:
          </p>
          <ul className="simple-list">
            <li><strong>/src:</strong> Código fuente de la aplicación</li>
            <li><strong>/components:</strong> Componentes reutilizables de React</li>
            <li><strong>/pages:</strong> Vistas principales del sistema</li>
            <li><strong>/services:</strong> Lógica de comunicación con API</li>
            <li><strong>/utils:</strong> Funciones auxiliares y helpers</li>
            <li><strong>/models:</strong> Modelos de datos y esquemas</li>
            <li><strong>/controllers:</strong> Lógica de negocio del backend</li>
            <li><strong>/routes:</strong> Definición de endpoints de API</li>
          </ul>
        </section>

        {/* Acuerdos de Nivel de Servicio */}
        <section className="manual-section">
          <h2>Acuerdos de Nivel de Servicio (ANS)</h2>
          
          <div className="function-item">
            <h3>Procedimiento de Escalado</h3>
            <p>
              El sistema cuenta con procedimientos definidos para el escalado de soporte técnico, 
              garantizando tiempos de respuesta según la criticidad del incidente.
            </p>
          </div>

          <div className="function-item">
            <h3>Instrucciones de Escalado</h3>
            <p>
              Instrucciones detalladas para la escalación de problemas técnicos desde el primer 
              nivel de soporte hasta el equipo de desarrollo.
            </p>
          </div>
        </section>

        {/* Download PDF */}
        <section className="manual-section download-pdf">
          <h2>📄 Descargar Manual Completo</h2>
          <p>
            Para obtener el manual técnico completo con diagramas, modelos de base de datos 
            y documentación detallada del código:
          </p>
          <a 
            href="/documents/Manual técnico Bitevia software.pdf" 
            className="pdf-download-btn technical"
            target="_blank"
            rel="noopener noreferrer"
          >
            Descargar PDF (2.5 MB)
          </a>
        </section>

      </div>
    </div>
  );
};

export default ManualTecnicoPage;
