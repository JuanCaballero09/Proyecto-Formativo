import "@hotwired/turbo-rails"
import "script"
import "chart"


// ===========================================
// DASHBOARD CAROUSEL FUNCTIONALITY
// ===========================================

document.addEventListener('DOMContentLoaded', function() {
    initializeCarousel();
    initializeScrollAnimations();
    initializeButtonStates();
    initializeSmoothScroll();
    initializeNavbarEffects();
    initializeSearchEnhancements();
    initializeFlashAlerts();
});

// ===========================================
// SISTEMA DE ALERTAS FLASH MEJORADO
// ===========================================

function initializeFlashAlerts() {
    // Agregar soporte para múltiples alertas
    const alertContainer = document.getElementById('alert-container');
    if (!alertContainer) return;
    
    // Función para crear alertas programáticamente
    window.createFlashAlert = function(message, type = 'info', duration = 4000) {
        const alert = document.createElement('div');
        alert.className = `alert ${type}`;
        alert.dataset.alertType = type;
        
        // Crear el HTML de la alerta
        alert.innerHTML = `
            <span class="alert-icon"></span>
            <span class="alert-message">${message}</span>
            <button class="alert-close" onclick="closeFlashAlert(this.parentElement)">&times;</button>
            <div class="alert-progress"></div>
        `;
        
        // Agregar al contenedor
        const flashToast = document.getElementById('flash-toast') || alertContainer;
        flashToast.appendChild(alert);
        
        // Aplicar animación y auto-close
        setTimeout(() => {
            alert.style.animation = "alertSlideIn 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards";
        }, 100);
        
        // Auto-close
        if (duration > 0) {
            setTimeout(() => {
                closeFlashAlert(alert);
            }, duration);
        }
        
        return alert;
    };
    
    // Función para cerrar alertas
    window.closeFlashAlert = function(alertElement) {
        if (!alertElement || alertElement.classList.contains('removing')) return;
        
        alertElement.classList.add('removing');
        alertElement.style.animation = "alertSlideOut 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards";
        
        alertElement.addEventListener("animationend", () => {
            if (alertElement.parentNode) {
                alertElement.remove();
            }
        }, { once: true });
    };
    
    // Función para limpiar todas las alertas
    window.clearAllAlerts = function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => closeFlashAlert(alert));
    };
    
    // Atajos de teclado para cerrar alertas
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            const alerts = document.querySelectorAll('.alert:not(.removing)');
            if (alerts.length > 0) {
                closeFlashAlert(alerts[alerts.length - 1]); // Cerrar la última alerta
            }
        }
    });
}

// ===========================================
// EFECTOS DEL NAVBAR Y HEADER
// ===========================================

function initializeNavbarEffects() {
    const navbar = document.querySelector('.navbar');
    
    if (!navbar) return;
    
    // Efecto de scroll en navbar
    let lastScrollTop = 0;
    
    window.addEventListener('scroll', () => {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        
        // Añadir/quitar clase para efecto de scroll
        if (scrollTop > 100) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
        
        lastScrollTop = scrollTop;
    });
    
    // Añadir clases CSS para el efecto scrolled
    const style = document.createElement('style');
    style.textContent = `
        .navbar.scrolled {
            background: linear-gradient(135deg, rgba(237, 88, 33, 0.95), rgba(157, 46, 6, 0.95));
            backdrop-filter: blur(15px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.2);
        }
    `;
    document.head.appendChild(style);
}

function initializeSearchEnhancements() {
    const searchInput = document.querySelector('.buscador input[type="search"]');
    const searchForm = document.querySelector('.buscador');
    
    if (!searchInput || !searchForm) return;
    
    // Efecto de focus mejorado
    searchInput.addEventListener('focus', () => {
        searchForm.classList.add('focused');
    });
    
    searchInput.addEventListener('blur', () => {
        searchForm.classList.remove('focused');
    });
    
    // Búsqueda con Enter
    searchInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            searchForm.submit();
        }
    });
    
    // Añadir estilos para el estado focused
    const style = document.createElement('style');
    style.textContent = `
        .buscador.focused {
            border-color: var(--base) !important;
            box-shadow: 0 12px 35px rgba(237, 88, 33, 0.2) !important;
            transform: translateY(-3px) !important;
        }
    `;
    document.head.appendChild(style);
}

// ===========================================
// FUNCIÓN PRINCIPAL DEL CAROUSEL
// ===========================================

function initializeCarousel() {
    const carousel = document.querySelector('.carousel-track');
    const slides = document.querySelectorAll('.carousel-slide');
    const prevBtn = document.querySelector('.carousel-control.prev');
    const nextBtn = document.querySelector('.carousel-control.next');
    const indicators = document.querySelectorAll('.indicator');
    
    // Verificar que existan los elementos necesarios
    if (!carousel || slides.length === 0) {
        console.log('Carousel elements not found or no slides available');
        return;
    }
    
    let currentSlide = 0;
    const totalSlides = slides.length;
    let autoPlayInterval;
    let isTransitioning = false;
    
    // Función para actualizar el carousel con animaciones mejoradas
    function updateCarousel(withAnimation = true) {
        if (isTransitioning && withAnimation) return;
        
        isTransitioning = true;
        
        const translateX = -currentSlide * 100;
        
        if (withAnimation) {
            carousel.style.transition = 'transform 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94)';
        } else {
            carousel.style.transition = 'none';
        }
        
        carousel.style.transform = `translateX(${translateX}%)`;
        
        // Actualizar indicadores con animación
        indicators.forEach((indicator, index) => {
            indicator.classList.toggle('active', index === currentSlide);
        });
        
        // Actualizar slides activos
        slides.forEach((slide, index) => {
            slide.classList.toggle('active', index === currentSlide);
        });
        
        // Reset transition flag
        setTimeout(() => {
            isTransitioning = false;
        }, withAnimation ? 600 : 50);
    }
    
    // Función para ir al siguiente slide
    function nextSlide() {
        if (isTransitioning) return;
        currentSlide = (currentSlide + 1) % totalSlides;
        updateCarousel(true);
        announceSlideChange();
    }
    
    // Función para ir al slide anterior
    function prevSlide() {
        if (isTransitioning) return;
        currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
        updateCarousel(true);
        announceSlideChange();
    }
    
    // Función para ir a un slide específico
    function goToSlide(index) {
        if (isTransitioning || index === currentSlide || index < 0 || index >= totalSlides) return;
        currentSlide = index;
        updateCarousel(true);
        announceSlideChange();
    }
    
    // Función para anunciar cambios de slide (accesibilidad)
    function announceSlideChange() {
        const announcement = `Slide ${currentSlide + 1} de ${totalSlides}`;
        console.log(announcement);
    }
    
    // Auto-play del carousel con mejores controles
    function startAutoPlay() {
        if (autoPlayInterval) clearInterval(autoPlayInterval);
        autoPlayInterval = setInterval(() => {
            if (!isTransitioning && !document.hidden) {
                nextSlide();
            }
        }, 6000); // Cambia cada 6 segundos
    }
    
    function stopAutoPlay() {
        if (autoPlayInterval) {
            clearInterval(autoPlayInterval);
            autoPlayInterval = null;
        }
    }
    
    function restartAutoPlay(delay = 0) {
        stopAutoPlay();
        if (delay > 0) {
            setTimeout(startAutoPlay, delay);
        } else {
            startAutoPlay();
        }
    }
    
    // Iniciar auto-play solo si hay más de un slide
    if (totalSlides > 1) {
        startAutoPlay();
    }
    
    // Pausar auto-play al hover y cuando la página no está visible
    const carouselContainer = document.querySelector('.carousel-container');
    if (carouselContainer) {
        carouselContainer.addEventListener('mouseenter', stopAutoPlay);
        carouselContainer.addEventListener('mouseleave', () => {
            if (totalSlides > 1) startAutoPlay();
        });
    }
    
    // Pausar cuando la página no está visible
    document.addEventListener('visibilitychange', () => {
        if (document.hidden) {
            stopAutoPlay();
        } else if (totalSlides > 1) {
            startAutoPlay();
        }
    });
    
    // Event listeners para controles con mejor manejo
    if (nextBtn) {
        nextBtn.addEventListener('click', (e) => {
            e.preventDefault();
            nextSlide();
            restartAutoPlay(); // Reinicia inmediatamente
        });
    }
    
    if (prevBtn) {
        prevBtn.addEventListener('click', (e) => {
            e.preventDefault();
            prevSlide();
            restartAutoPlay(); // Reinicia inmediatamente
        });
    }
    
    // Event listeners para indicadores
    indicators.forEach((indicator, index) => {
        indicator.addEventListener('click', (e) => {
            e.preventDefault();
            goToSlide(index);
            restartAutoPlay();
        });
        
        // Mejorar accesibilidad
        indicator.setAttribute('role', 'button');
        indicator.setAttribute('aria-label', `Ir al slide ${index + 1}`);
        indicator.setAttribute('tabindex', '0');
        
        // Soporte para Enter y Space
        indicator.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                goToSlide(index);
                restartAutoPlay();
            }
        });
    });
    
    // Soporte para touch/swipe en dispositivos móviles
    let touchStartX = 0;
    let touchEndX = 0;
    let isTouching = false;
    
    function handleTouchStart(e) {
        isTouching = true;
        touchStartX = e.touches[0].clientX;
        stopAutoPlay();
    }
    
    function handleTouchMove(e) {
        if (!isTouching) return;
        // Prevenir scroll vertical durante el swipe horizontal
        e.preventDefault();
    }
    
    function handleTouchEnd(e) {
        if (!isTouching) return;
        isTouching = false;
        touchEndX = e.changedTouches[0].clientX;
        
        const swipeThreshold = 50;
        const swipeDistance = touchStartX - touchEndX;
        
        if (Math.abs(swipeDistance) > swipeThreshold) {
            if (swipeDistance > 0) {
                // Swipe izquierda - siguiente slide
                nextSlide();
            } else {
                // Swipe derecha - slide anterior
                prevSlide();
            }
        }
        
        restartAutoPlay();
    }
    
    // Agregar event listeners para touch
    if (carouselContainer) {
        carouselContainer.addEventListener('touchstart', handleTouchStart, { passive: true });
        carouselContainer.addEventListener('touchmove', handleTouchMove, { passive: false });
        carouselContainer.addEventListener('touchend', handleTouchEnd, { passive: true });
    }
    
    // Soporte para navegación con teclado mejorado
    function handleKeyboardNavigation(e) {
        // Solo responder si el carousel está en foco
        if (!carouselContainer || !carouselContainer.contains(document.activeElement)) return;
        
        switch(e.key) {
            case 'ArrowLeft':
                e.preventDefault();
                prevSlide();
                restartAutoPlay();
                break;
            case 'ArrowRight':
                e.preventDefault();
                nextSlide();
                restartAutoPlay();
                break;
            case 'Home':
                e.preventDefault();
                goToSlide(0);
                restartAutoPlay();
                break;
            case 'End':
                e.preventDefault();
                goToSlide(totalSlides - 1);
                restartAutoPlay();
                break;
        }
    }
    
    document.addEventListener('keydown', handleKeyboardNavigation);
    
    // Mejorar accesibilidad del contenedor
    if (carouselContainer) {
        carouselContainer.setAttribute('role', 'region');
        carouselContainer.setAttribute('aria-label', 'Carousel de productos destacados');
        carouselContainer.setAttribute('tabindex', '0');
    }
    
    // Añadir atributos de accesibilidad a los controles
    if (prevBtn) {
        prevBtn.setAttribute('aria-label', 'Slide anterior');
        prevBtn.innerHTML = '<i class="fas fa-chevron-left" aria-hidden="true"></i>';
    }
    
    if (nextBtn) {
        nextBtn.setAttribute('aria-label', 'Slide siguiente');
        nextBtn.innerHTML = '<i class="fas fa-chevron-right" aria-hidden="true"></i>';
    }
    
    // Inicializar el carousel
    updateCarousel(false);
    
    // Añadir clases CSS para transiciones suaves
    carousel.style.willChange = 'transform';
    
    console.log(`Carousel inicializado con ${totalSlides} slides`);
}

// ===========================================
// SMOOTH SCROLL PARA NAVEGACIÓN
// ===========================================

function initializeSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

// ===========================================
// ANIMACIONES DE SCROLL
// ===========================================

function initializeScrollAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in');
            }
        });
    }, observerOptions);
    
    // Observar elementos para animaciones
    document.querySelectorAll('.combo-card-premium, .contact-item, .section-header').forEach(el => {
        observer.observe(el);
    });
}

// ===========================================
// LOADING STATES PARA BOTONES
// ===========================================

function initializeButtonStates() {
    document.querySelectorAll('.combo-btn-premium, .hero-btn, .view-all-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            if (!this.disabled) {
                this.classList.add('loading');
                this.disabled = true;
                
                // Simular un tiempo de carga mínimo para mejor UX
                setTimeout(() => {
                    this.classList.remove('loading');
                    this.disabled = false;
                }, 1000);
            }
        });
    });
}

// ===========================================
// TURBO FRAME ENHANCEMENTS
// ===========================================

document.addEventListener('turbo:frame-load', function() {
    // Re-inicializar funcionalidades después de cargas turbo
    console.log('Turbo frame loaded, re-initializing components...');
    
    // Re-inicializar carousel si es necesario
    setTimeout(() => {
        initializeCarousel();
        initializeScrollAnimations();
        initializeButtonStates();
    }, 100);
});

// ===========================================
// RESPONSIVE HELPERS
// ===========================================

function handleResize() {
    // Ajustar carousel en dispositivos móviles
    const carousel = document.querySelector('.carousel-track');
    if (carousel && window.innerWidth <= 768) {
        // Ajustes específicos para móvil si es necesario
        console.log('Responsive adjustments for mobile');
    }
}

window.addEventListener('resize', handleResize);
handleResize(); // Ejecutar al cargar