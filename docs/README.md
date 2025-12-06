# 🍕 Documentación Bitevia Software

Página de documentación oficial del proyecto **Bitevia Software** desarrollada con React + Vite.

## ✨ Características Principales

- **🎨 Diseño Moderno** con los colores oficiales de Bitevia (#ff5722)
- **📱 Totalmente Responsive** adaptado para móvil, tablet y desktop
- **🎭 Animaciones Avanzadas** con transiciones suaves y efectos visuales
- **🛡️ Manejo de Errores Global** con ErrorBoundary de React
- **📧 Gestión Inteligente de Correos** - Gmail en desktop, mailto en móvil
- **🚀 Optimización de Rendimiento** con lazy loading de imágenes
- **♿ Accesibilidad** con atributos ARIA y navegación por teclado
- **🔝 Scroll to Top** con botón flotante

## 📁 Estructura del Proyecto

```
/src
  /components
    - Navbar.jsx         # Barra de navegación responsive
    - Header.jsx         # Encabezado con logo animado
    - Home.jsx           # Sección de bienvenida
    - Integrantes.jsx    # Tarjetas de miembros del equipo
    - Documentos.jsx     # Lista de documentos del proyecto
    - Recursos.jsx       # Recursos y tecnologías
    - ScrollToTop.jsx    # Botón de scroll hacia arriba
    - ErrorBoundary.jsx  # Componente de manejo de errores
  /hooks
    - useIsMobile.js     # Hook para detectar dispositivos móviles
  /config
    - documentos.js      # Configuración centralizada de documentos
  - App.jsx             # Componente principal
  - App.css             # Estilos globales con animaciones
  - main.jsx            # Punto de entrada
```

## 📋 Requisitos Previos

Asegúrate de tener las siguientes carpetas y archivos en `/public`:

### 📂 `/public/img/icons/`
- `LogoLogo.svg` - Favicon del sitio
- `LogoLogoText2.svg` - Logo principal del header

### 📂 `/public/img/`
Logos de tecnologías:
- `Ruby_logo.png`
- `Dart_logo.png`
- `html-logo.webp`
- `css_logo.png`
- `javascript_logo.webp`
- `rails_logo.png`
- `flutter_logo.png`
- `bootstrap_logo.png`

### 📂 `/public/documents/`
Documentos del proyecto (PDFs e imágenes):
- `Diagrama_Clase.pdf`
- `Diagrama_Entidad_Relacion.pdf`
- `Esquemabasededatos.png`
- `macckup30-04-2025 15.36.pdf`
- `MackupAppMovil.pdf`
- `actaR2.pdf`
- `DiagramaCasoUsoAdmin.pdf`
- `fichaCasoUsoAdmin.pdf`
- `DiagramaCasoUsoClientes.pdf`
- `fichaCasoUsoCliente.pdf`

## 🛠️ Instalación y Ejecución

```bash
# Clonar el repositorio (si aplica)
git clone [url-del-repositorio]
cd BiteviaDocumentacion

# Instalar dependencias
npm install

# Ejecutar en modo desarrollo
npm run dev

# Compilar para producción
npm run build

# Previsualizar la compilación de producción
npm run preview
```

## 🎨 Personalización

### 🎨 Cambiar Colores del Tema

Edita las variables CSS en `src/App.css`:

```css
:root {
  --primary-color: #ff5722;      /* Color principal */
  --secondary-color: #ff8a65;    /* Color secundario */
  --dark-color: #d84315;         /* Color oscuro */
  --light-bg: #fff3e0;           /* Fondo claro */
}
```

### 👥 Modificar Integrantes

Edita el array en `src/components/Integrantes.jsx`:

```javascript
const integrantes = [
  {
    nombre: "Nombre",
    apellido: "Apellido",
    github: "https://github.com/usuario",
    email: "correo@ejemplo.com"
  },
  // ... más integrantes
];
```

### 📄 Agregar/Modificar Documentos

Edita el archivo `src/config/documentos.js`:

```javascript
export const documentos = [
  {
    titulo: "Título del Documento",
    descripcion: "Descripción detallada...",
    archivo: "nombre_archivo.pdf"
  },
  // ... más documentos
];
```

### 🔧 Agregar Tecnologías/Recursos

Edita los arrays en `src/components/Recursos.jsx`:

```javascript
const lenguajes = [
  {
    nombre: "Lenguaje",
    img: "/img/logo.png",
    descripcion: "Descripción...",
    url: "https://..."
  }
];
```

## 🌟 Características Técnicas

### Animaciones CSS

- **fadeIn**: Entrada suave de elementos
- **slideInLeft/Right**: Deslizamiento lateral
- **pulse**: Pulsación continua
- **float**: Flotación suave
- **shimmer**: Efecto de brillo

### Responsive Design

| Dispositivo | Breakpoint | Columnas Grid |
|-------------|-----------|---------------|
| 📱 Móvil   | < 768px   | 1 columna     |
| 📱 Tablet  | 769-1024px| 2 columnas    |
| 💻 Desktop | > 1024px  | 3+ columnas   |

### Funcionalidades Inteligentes

- **Detección de dispositivo**: Hook personalizado `useIsMobile`
- **Correos contextuales**: Gmail en desktop, app nativa en móvil
- **Lazy loading**: Carga diferida de imágenes
- **Error boundaries**: Captura de errores en React
- **Scroll suave**: Navegación fluida entre secciones

## 📱 Navegación

El sitio incluye scroll automático suave entre secciones:

- 🏠 **Home** - Bienvenida e introducción
- 👥 **Integrantes** - Equipo de desarrollo
- 📚 **Documentos** - Documentación del proyecto
- 🔧 **Recursos** - Tecnologías utilizadas

## 👥 Integrantes del Proyecto

- **Juan Esteban** Caballero Goenaga - [@JuanCaballero09](https://github.com/JuanCaballero09)
- **Santiago David** Zambrano Izaquita - [@San5472](https://github.com/San5472)
- **Andrw Stiven** Barrera Poveda - [@andrw790](https://github.com/andrw790)
- **Wilber Eliécer** Robles Mercado - [@Tribalsoft](https://github.com/Tribalsoft)
- **Miguel Junior** Sarabia Soto - [@MiguelSarabiaSoto](https://github.com/MiguelSarabiaSoto)

## 🛠️ Tecnologías Utilizadas

- ⚛️ **React 18** - Biblioteca de UI
- ⚡ **Vite** - Build tool y dev server
- 🎨 **CSS3** - Estilos y animaciones
- 📦 **Font Awesome 6.5** - Iconos
- 🎯 **Hooks personalizados** - Lógica reutilizable

## 📄 Licencia

Este proyecto es parte de la documentación oficial de **Bitevia Software**.

---

Desarrollado con ❤️ por el equipo de Bitevia Software

