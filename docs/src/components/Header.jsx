import { useState } from 'react';

function Header() {
  const [imgError, setImgError] = useState(false);

  return (
    <header id="header-1">
      <h1>Bitevia Software</h1>
      {!imgError ? (
        <img 
          src="/img/icons/LogoLogoText2.svg" 
          className="logo" 
          alt="Bitevia Software Logo" 
          onError={() => setImgError(true)}
          loading="lazy"
        />
      ) : (
        <div style={{ color: 'white', fontSize: '1.2rem', padding: '2rem' }}>
          🍕 Bitevia
        </div>
      )}
    </header>
  );
}

export default Header;
