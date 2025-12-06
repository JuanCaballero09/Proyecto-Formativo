import React from 'react';

const ManualUsuarioPage = () => {
  return (
    <div className="manual-page">
      <div className="manual-container">
        
        {/* Header */}
        <header className="manual-header">
          <h1>Manual de Usuario</h1>
          <p className="manual-subtitle">Guía de uso del software Bitevia</p>
        </header>

        {/* Introducción */}
        <section className="manual-section">
          <p className="intro-text">
            Este manual explica paso a paso cómo manejar el software Bitevia, facilitando 
            su comprensión y uso. El sistema optimiza el proceso de toma de pedidos para 
            "La Terraza del Pri", ubicado en Calle 56 #34-6, Ciudadela Metropolitana, Soledad, Atlántico.
          </p>
        </section>

        {/* Requerimientos */}
        <section className="manual-section">
          <h2>Requerimientos</h2>
          
          <h3>Conocimientos necesarios</h3>
          <ul className="simple-list">
            <li>Informática básica</li>
            <li>Manejo de sistema operativo</li>
            <li>Conocimiento básico de teléfonos móviles</li>
            <li>Políticas de seguridad y tratamiento de datos personales</li>
          </ul>

          <h3>Hardware y Software</h3>
          <ul className="simple-list">
            <li><strong>Web:</strong> Navegador web moderno actualizado</li>
            <li><strong>Móvil:</strong> Dispositivo de gama media en adelante</li>
            <li>Equipo en óptimas condiciones para buen rendimiento</li>
          </ul>
        </section>

        {/* Política de Seguridad */}
        <section className="manual-section">
          <h2>Política de Seguridad</h2>
          <p>
            Todo usuario debe tener en cuenta las políticas de seguridad y el manejo de su 
            información personal. La información entregada se utilizará para:
          </p>
          <ul className="simple-list">
            <li>Manejo de datos para compras</li>
            <li>Creación de órdenes de pedido</li>
            <li>Creación de perfiles de usuario</li>
          </ul>
          <p className="warning-text">
            ⚠️ No comparta su cuenta para evitar problemas de seguridad.
          </p>
        </section>

        {/* Ingreso al Sistema */}
        <section className="manual-section">
          <h2>Ingreso al Sistema</h2>
          <p>
            <strong>Aplicativo Web:</strong> Puede visualizarlo libremente. Para realizar pedidos 
            debe crear una cuenta o iniciar sesión.
          </p>
          <p>
            <strong>Aplicativo Móvil:</strong> Debe crear su cuenta primero antes de ingresar.
          </p>
        </section>

        {/* Funciones Principales */}
        <section className="manual-section">
          <h2>Funciones del Sistema</h2>

          <div className="function-item">
            <h3>🏠 Vista Principal - Inicio</h3>
            <p>
              Página de bienvenida que presenta el software y sus funcionalidades principales.
            </p>
          </div>

          <div className="function-item">
            <h3>🍔 Menú</h3>
            <p>
              Visualización de todos los productos disponibles organizados por categorías. 
              Al hacer clic en cada producto se muestran detalles como ingredientes, precios 
              y opciones de personalización.
            </p>
          </div>

          <div className="function-item">
            <h3>🏷️ Categorías</h3>
            <p>
              Grupos de comida (Salchipapas, Hamburguesas, etc.) para facilitar la navegación. 
              Permite filtrar productos por tipo de comida.
            </p>
          </div>

          <div className="function-item">
            <h3>🌐 Cambio de Idioma</h3>
            <p>
              Botón para cambiar el idioma del sistema a inglés. Traduce automáticamente 
              los textos y convierte la moneda a dólares.
            </p>
          </div>

          <div className="function-item">
            <h3>🛒 Carrito de Compras</h3>
            <p>Vista donde puede:</p>
            <ul className="simple-list">
              <li>Ver productos seleccionados</li>
              <li>Aumentar o disminuir cantidades</li>
              <li>Eliminar productos</li>
              <li>Generar código de orden de pago</li>
            </ul>
          </div>

          <div className="function-item">
            <h3>👤 Perfil de Usuario</h3>
            <p>Acceso a:</p>
            <ul className="simple-list">
              <li><strong>Mis Datos:</strong> Ver y editar información personal</li>
              <li><strong>Mis Pedidos:</strong> Historial de órdenes realizadas</li>
              <li><strong>Detalles de Compra:</strong> Información completa de cada pedido</li>
              <li><strong>Eliminar Cuenta:</strong> Opción para borrar la cuenta permanentemente</li>
            </ul>
          </div>

          <div className="function-item">
            <h3>⚙️ Panel de Administración</h3>
            <p>Exclusivo para usuarios administradores:</p>
            <ul className="simple-list">
              <li><strong>Gráficas:</strong> Productos más vendidos, ventas por categoría, crecimiento</li>
              <li><strong>Banners:</strong> Modificar imágenes promocionales de la vista principal</li>
              <li><strong>Grupos:</strong> Crear, editar, activar/desactivar y eliminar categorías</li>
              <li><strong>Productos:</strong> Gestión completa del menú</li>
              <li><strong>Ingredientes:</strong> Administrar inventario de ingredientes</li>
            </ul>
          </div>
        </section>

        {/* Aplicativo Móvil */}
        <section className="manual-section">
          <h2>Aplicativo Móvil</h2>
          <p>
            La versión móvil incluye las mismas funcionalidades adaptadas a dispositivos móviles:
          </p>
          <ul className="simple-list">
            <li>Navegación táctil optimizada</li>
            <li>Notificaciones push de estado de pedidos</li>
            <li>Interfaz adaptativa según tamaño de pantalla</li>
            <li>Acceso rápido al carrito y perfil</li>
          </ul>
        </section>

        {/* Mesa de Ayuda */}
        <section className="manual-section">
          <h2>Mesa de Ayuda</h2>
          <p>
            Para soporte técnico o resolver dudas sobre el funcionamiento del sistema, 
            contacte al equipo de desarrollo o administrador del establecimiento.
          </p>
        </section>

        {/* Mensajes de Error Comunes */}
        <section className="manual-section">
          <h2>Mensajes de Error Comunes</h2>
          <ul className="simple-list">
            <li><strong>"Debe iniciar sesión":</strong> Requiere crear cuenta o autenticarse</li>
            <li><strong>"Producto no disponible":</strong> El item está agotado temporalmente</li>
            <li><strong>"Error de conexión":</strong> Verifique su conexión a Internet</li>
            <li><strong>"Datos incorrectos":</strong> Revise la información ingresada</li>
          </ul>
        </section>

        {/* Download PDF */}
        <section className="manual-section download-pdf">
          <h2>📄 Descargar Manual Completo</h2>
          <p>
            Para obtener el manual completo en PDF con capturas de pantalla detalladas:
          </p>
          <a 
            href="/documents/Manual de usuario Bitevia software.pdf" 
            className="pdf-download-btn"
            target="_blank"
            rel="noopener noreferrer"
          >
            Descargar PDF (4.2 MB)
          </a>
        </section>

      </div>
    </div>
  );
};

export default ManualUsuarioPage;
