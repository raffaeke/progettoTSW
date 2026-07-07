<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.Prodotto" %>
<%@page import="daoImpl.ProdottoDAOImpl" %>
<%@page import="daoImpl.ImgDAOImpl" %>
<%@page import="java.util.List" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="refresh" content="30">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Kick Off</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Barlow:wght@400;600;700;800&family=Barlow+Condensed:wght@600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/base.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/index.css">
</head>

<body data-ctx="<%= request.getContextPath() %>">

  <header class="main-header">
    <nav class="nav-left">
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=MAGLIE">Maglie</a>
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=COMPLETO">Completi</a>
    </nav>

    <a href="<%= request.getContextPath() %>/" class="logo-link">
      <img src="<%= request.getContextPath() %>/images/logo.png" alt="Kick Off Logo">
    </a>

    <nav class="nav-right">
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=GUANTONI">Guantoni</a>
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=SCARPE">Scarpe</a>

      <a href="${pageContext.request.contextPath}/view/carrello" class="icon-link" aria-label="Carrello">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
             stroke-linecap="round" stroke-linejoin="round">
          <circle cx="9" cy="21" r="1"/>
          <circle cx="20" cy="21" r="1"/>
          <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
        </svg>
      </a>

      <% if (session.getAttribute("utente") != null) { %>
        <a href="${pageContext.request.contextPath}/view/profilo" class="icon-link icon-link--active" aria-label="Profilo">
      <% } else { %>
        <a href="${pageContext.request.contextPath}/view/login" class="icon-link" aria-label="Accedi">
      <% } %>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
               stroke-linecap="round" stroke-linejoin="round">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
          </svg>
        </a>
    </nav>
  </header>

  <main>

    <!-- ===== SLIDES + RICERCA ===== -->
    <section class="hero-section">

      <!-- SLIDES -->
      <div class="carousel" id="carousel">
        <div class="slides-track" id="slidesTrack">

          <!-- Slide 1: Maglie -->
          <div class="slide slide--green">
            <div class="slide-deco">
            <!--  Grafica  -->
              <svg width="340" height="260" viewBox="0 0 340 260" aria-hidden="true">
                <rect x="0" y="0" width="340" height="130" fill="#1a5e22"/>
                <rect x="0" y="130" width="340" height="130" fill="#1e6b27"/>
                <line x1="0" y1="130" x2="340" y2="130" stroke="rgba(255,255,255,0.5)" stroke-width="2"/>
                <circle cx="170" cy="130" r="50" fill="none" stroke="rgba(255,255,255,0.5)" stroke-width="2"/>
                <rect x="110" y="0" width="120" height="40" fill="none" stroke="rgba(255,255,255,0.5)" stroke-width="2"/>
                <rect x="110" y="220" width="120" height="40" fill="none" stroke="rgba(255,255,255,0.5)" stroke-width="2"/>
                <rect x="135" y="0" width="70" height="18" fill="none" stroke="rgba(255,255,255,0.4)" stroke-width="1.5"/>
                <rect x="135" y="242" width="70" height="18" fill="none" stroke="rgba(255,255,255,0.4)" stroke-width="1.5"/>
                <circle cx="170" cy="130" r="3" fill="rgba(255,255,255,0.8)"/>
              </svg>
            </div>
            <div class="slide-content">
              <span class="slide-kicker">Nuova collezione 26/27</span>
              <h2 class="slide-title">Vesti il tuo<br>gioco.</h2>
              <p class="slide-sub">Maglie ufficiali e da allenamento per chi vive il calcio ogni giorno.</p>
              <a href="<%= request.getContextPath() %>/Catalogo?tipo=MAGLIE"" class="slide-btn slide-btn--green">Scopri le maglie</a>
            </div>
          </div>

          <!-- Slide 2: Guantoni -->
          <div class="slide slide--blue">
            <div class="slide-deco">
            <!--  Grafica  -->
              <svg width="300" height="260" viewBox="0 0 300 260" aria-hidden="true">
                <ellipse cx="150" cy="130" rx="110" ry="80" fill="none" stroke="rgba(74,127,193,0.6)" stroke-width="2"/>
                <ellipse cx="150" cy="130" rx="70" ry="50" fill="none" stroke="rgba(74,127,193,0.4)" stroke-width="1.5"/>
                <ellipse cx="150" cy="130" rx="35" ry="25" fill="none" stroke="rgba(74,127,193,0.3)" stroke-width="1"/>
                <line x1="150" y1="50" x2="150" y2="210" stroke="rgba(74,127,193,0.3)" stroke-width="1" stroke-dasharray="6 4"/>
                <line x1="40" y1="130" x2="260" y2="130" stroke="rgba(74,127,193,0.3)" stroke-width="1" stroke-dasharray="6 4"/>
              </svg>
            </div>
            <div class="slide-content">
              <span class="slide-kicker">Attrezzatura pro</span>
              <h2 class="slide-title">Protezione<br>totale.</h2>
              <p class="slide-sub">Guantoni da portiere di livello professionale. Grip, comfort e sicurezza.</p>
              <a href="<%= request.getContextPath() %>/Catalogo?tipo=GUANTONI" class="slide-btn slide-btn--blue">Vedi guantoni</a>
            </div>
          </div>

          <!-- Slide 3: Scarpette -->
          <div class="slide slide--red">
            <div class="slide-deco">
            <!--  Grafica  -->
              <svg width="300" height="260" viewBox="0 0 300 260" aria-hidden="true">
                <path d="M40 220 L90 60 L150 130 L210 30 L270 220Z" fill="none" stroke="rgba(193,74,74,0.45)" stroke-width="2"/>
                <circle cx="90"  cy="60"  r="7" fill="rgba(193,74,74,0.55)"/>
                <circle cx="150" cy="130" r="7" fill="rgba(193,74,74,0.55)"/>
                <circle cx="210" cy="30"  r="7" fill="rgba(193,74,74,0.55)"/>
                <line x1="0" y1="220" x2="300" y2="220" stroke="rgba(193,74,74,0.3)" stroke-width="1.5"/>
              </svg>
            </div>
            <div class="slide-content">
              <span class="slide-kicker">Offerte limitate</span>
              <h2 class="slide-title">Scarpe<br>a &minus;15%.</h2>
              <p class="slide-sub">Le migliori scarpe FG e SG in promozione questa settimana.</p>
              <a href="<%= request.getContextPath() %>/Catalogo?tipo=SCARPE" class="slide-btn slide-btn--red">Approfitta ora</a>
            </div>
          </div>

        </div><!-- /slides-track -->

        <!-- Frecce navigazione slide -->
        <button class="carousel-arrow carousel-arrow--prev" id="carouselPrev" aria-label="Slide precedente">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="15 18 9 12 15 6"/>
          </svg>
        </button>
        <button class="carousel-arrow carousel-arrow--next" id="carouselNext" aria-label="Slide successiva">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="9 18 15 12 9 6"/>
          </svg>
        </button>

        <!-- Pallini slide -->
        <div class="carousel-dots" id="carouselDots" role="tablist" aria-label="Navigazione slide">
          <button class="carousel-dot active" data-index="0" role="tab" aria-label="Slide 1" aria-selected="true"></button>
          <button class="carousel-dot" data-index="1" role="tab" aria-label="Slide 2" aria-selected="false"></button>
          <button class="carousel-dot" data-index="2" role="tab" aria-label="Slide 3" aria-selected="false"></button>
        </div>

      </div>

      <!-- BARRA DI RICERCA -->
      <div class="search-section">
        <div class="search-bar">
          <div class="search-input-wrap">
            <svg class="search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input
              type="search"
              id="searchInput"
              class="search-input"
              placeholder="Cerca maglie, scarpette, guantoni..."
              autocomplete="off"
              aria-label="Cerca prodotti"
            >
            <div class="search-results-dropdown" id="searchResults" hidden></div>
          </div>
          <button class="search-submit" id="searchSubmit" type="button">Cerca</button>
        </div>

        <div class="search-tags">
          <span class="search-tags-label">Ricerche popolari:</span>
          <button class="search-tag" data-value="Nike Zoom Superfly 9 Academy">Nike Zoom Superfly 9 Academy</button>
          <button class="search-tag" data-value="Nike">Nike</button>
          <button class="search-tag" data-value="Real Madrid">Real Madrid</button>
          <button class="search-tag" data-value="Juventus">Juventus</button>
        </div>
      </div>

    </section>
    <!-- ===== FINE HERO ===== -->
<section class="featured-section">
      <div class="featured-header">
        <h2 class="featured-title">In evidenza</h2>
        <a href="${pageContext.request.contextPath}/view/Catalogo" class="featured-link">Vedi tutti &rarr;</a>
      </div>

      <div class="products-grid">

        <!-- Card 1 -->
        <%	Prodotto p1= new Prodotto();
        	ProdottoDAOImpl prodottodao= new ProdottoDAOImpl();
        	p1= prodottodao.doRetrieveByKey(6);
        	ImgDAOImpl imgdao= new ImgDAOImpl();
        %>
        <article class="product-card">
          <div class="product-img-wrap">
            <span class="product-badge product-badge--new">Nuovo</span>
            <img src="<%= request.getContextPath() %>/images/prodotti/<%= imgdao.doRetrieveByProductKey(p1.getId()).get(0) %>"
     			alt="<%=p1.getNome() %>"
     			class="product-img"
     			loading="lazy"
     			onerror="this.style.display='none'">
           <div class="product-hover-overlay">
              <a href="${pageContext.request.contextPath}/prodotto?id=6"
                 class="product-quick-btn">Aggiungi al carrello</a>
            </div>
          </div>
          <div class="product-info">
            <span class="product-brand">Nike</span>
            <h3 class="product-name">
              <a href="${pageContext.request.contextPath}/prodotto?id=6"><%=p1.getNome() %></a>
            </h3>
            <div class="product-footer">
              <span class="product-price">&euro;<%= p1.getPrezzo() %></span>
            </div>
          </div>
        </article>

        <!-- Card 2 -->
        <% Prodotto p2= new Prodotto();
    	p2= prodottodao.doRetrieveByKey(22);
    	
    	%>
        <article class="product-card">
          <div class="product-img-wrap">
            <span class="product-badge product-badge--sale">&minus;15%</span>
            <img src="<%= request.getContextPath() %>/images/prodotti/<%= imgdao.doRetrieveByProductKey(p2.getId()).get(0) %>"
     			alt="<%=p2.getNome() %>"
     			class="product-img"
     			loading="lazy"
     			onerror="this.style.display='none'">
           
            <div class="product-hover-overlay">
              <a href="${pageContext.request.contextPath}/prodotto?id=22"
                 class="product-quick-btn">Aggiungi al carrello</a>
            </div>
          </div>
          <div class="product-info">
            <span class="product-brand">Puma</span>
            <h3 class="product-name">
              <a href="${pageContext.request.contextPath}/prodotto?id=22"><%=p2.getNome() %></a>
            </h3>
            <div class="product-footer">
              <span class="product-price">&euro;<%= String.format("%.2f", p2.getPrezzoScontato()) %></span>
              <span class="product-price-original">&euro;<%= String.format("%.2f", p2.getPrezzo()) %></span>
            </div>
          </div>
        </article>

        <!-- Card 3 -->
        <%	Prodotto p3= new Prodotto();
        	p3= prodottodao.doRetrieveByKey(25);
        %>
        <article class="product-card">
          <div class="product-img-wrap">
            <img src="<%= request.getContextPath() %>/images/prodotti/<%= imgdao.doRetrieveByProductKey(p3.getId()).get(0) %>"
                 alt="<%=p3.getNome() %>"
                 class="product-img"
                 loading="lazy"
                 onerror="this.style.display='none'">
              <div class="product-hover-overlay">
              <a href="${pageContext.request.contextPath}/prodotto?id=25"
                 class="product-quick-btn">Aggiungi al carrello</a>
            </div>
          </div>
          <div class="product-info">
            <span class="product-brand">Adidas</span>
            <h3 class="product-name">
              <a href="${pageContext.request.contextPath}/prodotto?id=25"><%=p3.getNome() %></a>
            </h3>
            <div class="product-footer">
              <span class="product-price">&euro;<%=p3.getPrezzo() %></span>
            </div>
          </div>
        </article>

        <!-- Card 4 -->
        <% Prodotto p4= new Prodotto();
    		p4= prodottodao.doRetrieveByKey(41);
    	
    	%>
        <article class="product-card">
          <div class="product-img-wrap">
            <span class="product-badge product-badge--new">Nuovo</span>
            <img src="<%= request.getContextPath() %>/images/prodotti/<%= imgdao.doRetrieveByProductKey(p4.getId()).get(0) %>"
                 alt="<%=p4.getNome() %>"
                 class="product-img"
                 loading="lazy"
                 onerror="this.style.display='none'">
            <div class="product-hover-overlay">
              <a href="${pageContext.request.contextPath}/prodotto?id=41"
                 class="product-quick-btn">Aggiungi al carrello</a>
            </div>
          </div>
          <div class="product-info">
            <span class="product-brand">Adidas</span>
            <h3 class="product-name">
              <a href="${pageContext.request.contextPath}/prodotto?id=41"><%=p4.getNome() %></a>
            </h3>
            <div class="product-footer">
              <span class="product-price">&euro;<%=p4.getPrezzo() %></span>
            </div>
          </div>
        </article>

      </div><!-- /products-grid -->
    </section>

  </main>

  <%@ include file="/WEB-INF/view/parziali/footer.jsp" %>

  <script src="<%= request.getContextPath() %>/scripts/index.js"></script>
</body>
</html>
