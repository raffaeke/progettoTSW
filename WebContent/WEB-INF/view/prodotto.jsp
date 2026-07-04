<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Prodotto" %>
<%@ page import="model.Spec_prodotto" %>
<%@ page import="model.Recensione" %>
<%@ page import="model.Utente" %>
<%@ page import="daoImpl.UtenteDAOImpl" %>
<%
  // Recuperiamo i dati reali impostati dalla servlet tramite request.getAttribute
  Prodotto p = (Prodotto) request.getAttribute("prodotto");
  
  // Lista degli URL o oggetti immagine associati
  List<String> immagini = (List<String>) request.getAttribute("immagini");
  if (immagini == null) {
      immagini = new ArrayList<String>();
  }

  // Lista delle specifiche/taglie di magazzino per questo prodotto
  List<Spec_prodotto> specs = (List<Spec_prodotto>) request.getAttribute("specs");
  if (specs == null) {
      specs = new ArrayList<Spec_prodotto>();
  }

  // Lista delle recensioni rilasciate dagli utenti
  List<Recensione> recensioni = (List<Recensione>) request.getAttribute("recensioni");
  if (recensioni == null) {
      recensioni = new ArrayList<Recensione>();
  }

  // Controllo pulito e centralizzato dello sconto per evitare animazioni/badge errati se a 0
  boolean haSconto = (p != null && p.getSconto() > 0);
  float prezzoFinale = 0;
  if (p != null) {
      prezzoFinale = haSconto ? (p.getPrezzo() - (p.getPrezzo() * p.getSconto() / 100)) : p.getPrezzo();
  }
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= (p != null) ? p.getNome() : "Prodotto" %> — Kick Off</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Barlow:wght@400;600;700;800&family=Barlow+Condensed:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/base.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/prodotto.css">
</head>

<body data-ctx="<%= request.getContextPath() %>">

  <%-- ===== HEADER ===== --%>
  <header class="main-header">
    <nav class="nav-left">
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=MAGLIE">Maglie</a>
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=COMPLETO">Completi</a>
    </nav>
    <a href="<%= request.getContextPath() %>/" class="logo-link">
      <img src="<%= request.getContextPath() %>/images/logo.png" alt="Kick Off">
    </a>
    <nav class="nav-right">
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=GUANTONI">Guantoni</a>
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=SCARPE">Scarpette</a>
      <a href="<%= request.getContextPath() %>/view/carrello" class="icon-link" aria-label="Carrello">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
          <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
        </svg>
      </a>
      <% if (session.getAttribute("utente") != null) { %>
        <a href="<%= request.getContextPath() %>/view/profilo" class="icon-link icon-link--active" aria-label="Profilo">
      <% } else { %>
        <a href="<%= request.getContextPath() %>/view/login" class="icon-link" aria-label="Accedi">
      <% } %>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
          </svg>
        </a>
    </nav>
  </header>

  <% if (p != null) { %>
  <main class="prodotto-main">

    <%-- ===== BREADCRUMB ===== --%>
    <nav class="breadcrumb" aria-label="Breadcrumb">
      <a href="<%= request.getContextPath() %>/">Home</a>
      <span class="bc-sep">/</span>
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=<%= p.getCat().toString() %>"><%= p.getCat() %></a>
      <span class="bc-sep">/</span>
      <span class="bc-current"><%= p.getNome() %></span>
    </nav>

    <%-- ===== SCHEDA PRODOTTO ===== --%>
    <div class="prodotto-layout">

      <%-- ── GALLERIA IMMAGINI ── --%>
      <div class="gallery">

        <%-- Immagine principale --%>
        <div class="gallery-main" id="galleryMain">
          <% if (!immagini.isEmpty()) { %>
              <img id="mainImg"
                   src="<%= request.getContextPath() %>/images/prodotti/<%= immagini.get(0) %>"
                   alt="<%= p.getNome() %>"
                   class="gallery-img">
          <% } else { %>
              <div class="gallery-placeholder">
                <svg width="64" height="64" viewBox="0 0 64 64" fill="none">
                  <rect x="8" y="8" width="48" height="48" rx="6" stroke="#333" stroke-width="2"/>
                  <path d="M8 44 L22 30 L32 40 L44 26 L56 44Z" fill="#1e1e1e" stroke="#333" stroke-width="1.5"/>
                  <circle cx="22" cy="22" r="5" fill="#2a2a2a" stroke="#333" stroke-width="1.5"/>
                </svg>
              </div>
          <% } %>

          <%-- Badge sconto reale valorizzato solo se > 0 --%>
          <% if (haSconto) { %>
            <span class="gallery-badge">-<%= p.getSconto() %>%</span>
          <% } %>
        </div>

        <%-- Thumbnails (mostrate solo se c'è più di una foto) --%>
        <% if (immagini.size() > 1) { %>
          <div class="gallery-thumbs" id="galleryThumbs">
            <% for (int i = 0; i < immagini.size(); i++) { %>
              <button type="button"
                      class="thumb-btn <%= (i == 0) ? "active" : "" %>"
                      data-src="<%= request.getContextPath() %>/images/prodotti/<%= immagini.get(i) %>"
                      aria-label="Immagine <%= i + 1 %>">
                <img src="<%= request.getContextPath() %>/images/prodotti/<%= immagini.get(i) %>"
                     alt="<%= p.getNome() %> — foto <%= i + 1 %>"
                     loading="lazy">
              </button>
            <% } %>
          </div>
        <% } %>

      </div>

      <%-- ── INFO PRODOTTO ── --%>
      <div class="prodotto-info">

        <span class="prod-marca"><%= p.getMarca() %></span>
        <h1 class="prod-nome"><%= p.getNome() %></h1>
        <p class="prod-categoria">
          <a href="<%= request.getContextPath() %>/Catalogo?tipo=<%= p.getCat().toString() %>"><%= p.getCat() %></a>
        </p>

        <%-- Prezzo --%>
        <div class="prod-prezzi">
          <% if (haSconto) { %>
              <span class="prezzo-attuale">€<%= String.format("%.2f", prezzoFinale) %></span>
              <span class="prezzo-originale">€<%= String.format("%.2f", p.getPrezzo()) %></span>
              <span class="prezzo-risparmio">Risparmi €<%= String.format("%.2f", p.getPrezzo() - prezzoFinale) %></span>
          <% } else { %>
              <span class="prezzo-attuale">€<%= String.format("%.2f", p.getPrezzo()) %></span>
          <% } %>
        </div>

        <%-- Descrizione --%>
        <p class="prod-descr"><%= p.getDesc() %></p>

        <div class="prod-divider"></div>

        <%-- Selezione taglia --%>
        <div class="taglia-section">
          <div class="taglia-header">
            <span class="taglia-label">Taglia</span>
            <span class="taglia-selezionata" id="tagliaSel">— seleziona —</span>
          </div>
          <div class="taglia-grid" id="tagliaGrid">
            <% for (Spec_prodotto spec : specs) { 
                boolean esaurita = (spec.getQuantita() == 0);
            %>
              <button type="button"
                      class="taglia-btn <%= esaurita ? "esaurita" : "" %>"
                      data-taglia="<%= spec.getTaglia() %>"
                      data-spec-id="<%= spec.getId() %>"
                      data-qty="<%= spec.getQuantita() %>"
                      <%= esaurita ? "disabled" : "" %>
                      aria-label="Taglia <%= spec.getTaglia() %><%= esaurita ? " - esaurita" : "" %>">
                <%= spec.getTaglia() %>
                <% if (esaurita) { %>
                  <span class="taglia-esaurita-line"></span>
                <% } %>
              </button>
            <% } %>
          </div>
          <p class="taglia-avviso" id="tagliaAvviso" hidden>Seleziona una taglia per continuare.</p>
        </div>

        <%-- CTA --%>
        <div class="cta-group">
          <a href="#"
             id="btnCarrello"
             class="btn-primary"
             onclick="return aggiungiCarrello(event)">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
              <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
            </svg>
            Aggiungi al carrello
          </a>
        </div>

        <%-- Info spedizione --%>
        <div class="spedizione-info">
          <div class="sped-row">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#2f8f3a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="1" y="3" width="15" height="13" rx="1"/><path d="M16 8h4l3 5v3h-7V8z"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
            <span>Spedizione gratuita sopra <strong>€80</strong></span>
          </div>
          <div class="sped-row">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#2f8f3a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg>
            <span>Resi gratuiti entro <strong>30 giorni</strong></span>
          </div>
        </div>

      </div>

    </div>

    <%-- ===== RECENSIONI ===== --%>
    <section class="recensioni-section">
      <div class="rec-header">
        <h2 class="rec-title">Recensioni</h2>
        <span class="rec-count"><%= recensioni.size() %> recensioni</span>
      </div>

      <%-- Form nuova recensione (solo utenti loggati) --%>
      <% if (session.getAttribute("utente") != null) { %>
        <div class="rec-form-wrap">
          <h3 class="rec-form-title">Lascia una recensione</h3>
          <form action="<%= request.getContextPath() %>/Recensione" method="post" class="rec-form">
            <input type="hidden" name="prodottoId" value="<%= p.getId() %>">

            <div class="stars-input" id="starsInput" role="radiogroup" aria-label="Valutazione">
              <% for (int s = 1; s <= 5; s++) { %>
                <button type="button" class="star-btn" data-val="<%= s %>" aria-label="<%= s %> stelle">
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
                  </svg>
                </button>
              <% } %>
              <input type="hidden" name="voto" id="votoInput" value="0">
            </div>

            <textarea name="testo" class="rec-textarea" rows="4"
                      placeholder="Scrivi la tua esperienza con questo prodotto..."
                      maxlength="500" required></textarea>

            <button type="submit" class="btn-primary btn-sm">Pubblica recensione</button>
          </form>
        </div>
      <% } else { %>
        <p class="rec-login-msg">
          <a href="<%= request.getContextPath() %>/view/login">Accedi</a> per lasciare una recensione.
        </p>
      <% } %>

      <%-- Lista recensioni --%>
      <div class="rec-list">
        <% if (!recensioni.isEmpty()) { 
            for (Recensione r : recensioni) { 
            	UtenteDAOImpl utenteDAO= new UtenteDAOImpl();
          	  Utente u=utenteDAO.doRetrieveById(r.getUtenteId());
              String iniziali = "";
              if (r.getUtenteId() != 0) {
            
                  iniziali += u.getNome().substring(0, 1) + u.getCognome().substring(0, 1);
              }
        %>
          <article class="rec-card">
            <div class="rec-card-header">
              <div class="rec-avatar"><%= iniziali.toUpperCase() %></div>
              <div class="rec-meta">
                <span class="rec-autore">
                  <%= (r.getUtenteId() != 0) ? (u.getNome() + " " + u.getCognome()) : "Utente Kick Off" %>
                </span>
                <div class="rec-stars" aria-label="<%= r.getVoto() %> su 5 stelle">
                  <% for (int s = 1; s <= 5; s++) { 
                      boolean accesa = (s <= r.getVoto());
                  %>
                    <svg width="14" height="14" viewBox="0 0 24 24"
                         fill="<%= accesa ? "#2f8f3a" : "none" %>"
                         stroke="<%= accesa ? "#2f8f3a" : "#444" %>"
                         stroke-width="1.5">
                      <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
                    </svg>
                  <% } %>
                </div>
              </div>
            </div>
            <p class="rec-testo">${r.testo}</p>
          </article>
        <% } } else { %>
          <p class="rec-empty">Nessuna recensione ancora. Sii il primo!</p>
        <% } %>
      </div>

    </section>

  </main>
  <% } else { %>
  <main class="prodotto-main">
      <p class="rec-empty">Prodotto non trovato o non disponibile.</p>
  </main>
  <% } %>

  <%@ include file="/WEB-INF/view/parziali/footer.jsp" %>

  <script src="<%= request.getContextPath() %>/scripts/prodotto.js"></script>
</body>
</html>