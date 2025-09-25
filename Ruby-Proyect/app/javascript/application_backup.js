import "@hotwired/turbo-rails"
import "script"
import "chart"

// ===========================================
// DASHBOARD CAROUSEL FUNCTIONALITY
// ===========================================

document.addEventListener('DOMContentLoaded', function() {
    initializeCarousel();
});

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
        
        // Event listeners para controles
        if (nextBtn) {
            nextBtn.addEventListener('click', nextSlide);
        }
        
        if (prevBtn) {
            prevBtn.addEventListener('click', prevSlide);
        }
        
        // Event listeners para indicadores
        indicators.forEach((indicator, index) => {
            indicator.addEventListener('click', () => goToSlide(index));
        });
        
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
    
    function restartAutoPlay(delay = 8000) {
        stopAutoPlay();
        setTimeout(startAutoPlay, delay);
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
            restartAutoPlay();
        });
    }
    
    if (prevBtn) {
        prevBtn.addEventListener('click', (e) => {
            e.preventDefault();
            prevSlide();
            restartAutoPlay();
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
        
    // Soporte para navegación con teclado mejorado
    function handleKeyboardNavigation(e) {
        // Solo responder si el carousel está en foco
        if (!carouselContainer.contains(document.activeElement)) return;
        
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
    
    // ===========================================
    // ANIMACIONES DE SCROLL
    // ===========================================
    
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
    
    // ===========================================
    // LOADING STATES PARA BOTONES
    // ===========================================
    
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
    
    // ===========================================
    // SMOOTH SCROLL PARA NAVEGACIÓN
    // ===========================================
    
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
    
    // ===========================================
    // ANIMACIONES DE SCROLL
    // ===========================================
    
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
// TURBO FRAME ENHANCEMENTS
// ===========================================

document.addEventListener('turbo:frame-load', function() {
    // Re-inicializar funcionalidades después de cargas turbo
    console.log('Turbo frame loaded, re-initializing components...');
    
    // Re-observar nuevos elementos para animaciones
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in');
            }
        });
    }, { threshold: 0.1 });
    
    document.querySelectorAll('.combo-card-premium:not(.fade-in)').forEach(el => {
        observer.observe(el);
    });
});

// ===========================================
// RESPONSIVE HELPERS
// ===========================================

function handleResize() {
    // Ajustar carousel en dispositivos móviles
    const carousel = document.querySelector('.carousel-track');
    if (carousel && window.innerWidth <= 768) {
        // Ajustes específicos para móvil si es necesario
    }
}

window.addEventListener('resize', handleResize);
handleResize(); // Ejecutar al cargar