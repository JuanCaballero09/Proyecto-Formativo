function toggleMenu() {
    document.getElementById('aside-1').classList.add('show');
}

function closeMenu() {
    document.getElementById('aside-1').classList.remove('show');
}

const elementos = document.querySelectorAll('.scroll-item');

const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('visible');
        } else {
            entry.target.classList.remove('visible');
        }
    });
}, {
    threshold: 0.4
});

elementos.forEach(el => observer.observe(el));

document.addEventListener('DOMContentLoaded', () => {
    const section = document.getElementById('section-1');
    const links = document.querySelectorAll('.nav-link');
    const aside = document.getElementById('aside-1');

    const isMobile = () => window.innerWidth <= 768; // o usa el mismo breakpoint que en tu CSS

    function loadView(viewName) {
        fetch(`views/${viewName}.html`)
            .then(res => res.text())
            .then(html => {
                section.innerHTML = html;
                section.scrollIntoView({ behavior: 'smooth' });
            })
            .catch(err => {
                section.innerHTML = '<p>Error al cargar la vista</p>';
                console.error('Error al cargar la vista:', err);
            });
    }

    function syncActive(linkClicked) {
        const view = linkClicked.getAttribute('data-section');
        links.forEach(link => {
            if (link.getAttribute('data-section') === view) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    }

    links.forEach(link => {
        link.addEventListener('click', e => {
            e.preventDefault();

            const view = link.getAttribute('data-section');
            const target = document.getElementById(view === 'integrantes' ? 'cont-inte' : view);

            syncActive(link);

            if (isMobile()) {
                loadView(view);
                aside.classList.remove('show');
            } else {
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth' });
                }
            }
        });
    });

    // Al cargar, si está en móvil, carga "home" por defecto
    if (isMobile()) {
        loadView('home');
    }
});
