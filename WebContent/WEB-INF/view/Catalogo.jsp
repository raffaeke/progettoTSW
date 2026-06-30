<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.beans.Categoria" %>
<%@ page import="model.beans.Prodotto" %>
<%@ page import="model.daoImpl.Spec_prodottoDAOImpl" %>
<%@ page import="model.daoImpl.ImgDAOImpl" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.beans.ProdottoCompleto" %> 
<%
  String tipoStr = (String) request.getAttribute("tipo");
  Categoria categoria = Categoria.MAGLIE; 
  if (tipoStr != null) {
      try {
          categoria = Categoria.valueOf(tipoStr.toUpperCase());
      } catch(IllegalArgumentException e) {
          // Fallback se l'enum non corrisponde
      }
  }

  List<Prodotto> listaProdotti = (List<Prodotto>) request.getAttribute("prodotti");
  if (listaProdotti == null) listaProdotti = new ArrayList<Prodotto>();

  List<Prodotto> listaInEvidenza = (List<Prodotto>) request.getAttribute("inEvidenza");
  if (listaInEvidenza == null) listaInEvidenza = new ArrayList<Prodotto>();

  List<Prodotto> listaPiuScontati = (List<Prodotto>) request.getAttribute("piuScontati");
  if (listaPiuScontati == null) listaPiuScontati = new ArrayList<Prodotto>();

  List<String> marche = (List<String>) request.getAttribute("marche");
  if (marche == null) marche = new ArrayList<String>();

  List<String> taglie = (List<String>) request.getAttribute("taglie");
  if (taglie == null) taglie = new ArrayList<String>();

  ImgDAOImpl imgDAO = new ImgDAOImpl();
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Catalogo — Kick Off</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Barlow:wght@400;600;700;800&family=Barlow+Condensed:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/catalogo.css">
  
  <style>
    /* Slider Orizzontale per le sezioni In Evidenza e Più Scontati */
    .products-slider {
        display: flex !important;
        flex-wrap: nowrap !important;
        overflow-x: auto;
        gap: 20px;
        padding-bottom: 15px;
        scroll-behavior: smooth;
        -webkit-overflow-scrolling: touch;
    }

    /* Personalizzazione barra di scorrimento dello slider */
    .products-slider::-webkit-scrollbar {
        height: 6px;
    }
    .products-slider::-webkit-scrollbar-track {
        background: rgba(0, 0, 0, 0.05);
        border-radius: 10px;
    }
    .products-slider::-webkit-scrollbar-thumb {
        background: #2f8f3a; 
        border-radius: 10px;
    }

    /* Forza esattamente 5 elementi visibili nell'area dello slider */
    .products-slider .product-card {
        flex: 0 0 calc((100% - (20px * 4)) / 5);
        min-width: calc((100% - (20px * 4)) / 5);
        box-sizing: border-box;
    }

    /* Griglia classica verticale mantenuta solo per Tutti i Prodotti */
    #gridTutti {
        display: grid !important;
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)) !important;
        gap: 20px;
    }
  </style>
</head>

<body data-ctx="<%= request.getContextPath() %>">

  <%-- ===== HEADER ===== --%>
  <header class="main-header">
    <nav class="nav-left">
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=MAGLIE">Maglie</a>
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=COMPLETI">Completi</a>
    </nav>
    <a href="<%= request.getContextPath() %>/index.jsp" class="logo-link">
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

  <main class="catalogo-main">

    <%-- ===== BREADCRUMB ===== --%>
    <nav class="breadcrumb" aria-label="Breadcrumb">
      <a href="<%= request.getContextPath() %>/index.jsp">Home</a>
      <span class="bc-sep">/</span>
      <span class="bc-current"><%= categoria %></span>
    </nav>

    <%-- ===== TITOLO CATEGORIA ===== --%>
    <div class="cat-hero">
      <h1 class="cat-title"><%= categoria %></h1>
      <span class="cat-count" id="prodCount"><%= listaProdotti.size() %> prodotti</span>
    </div>

    <div class="catalogo-layout">

      <%-- SIDEBAR FILTRI --%>
      <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
          <span class="sidebar-title">Filtri</span>
          <button type="button" class="reset-btn" id="resetBtn">Azzera</button>
        </div>

        <%-- Prezzo --%>
        <div class="filter-group" id="fPrezzo">
          <button type="button" class="filter-toggle" aria-expanded="true" data-target="prezzo-body">
            Prezzo <svg class="chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
          </button>
          <div class="filter-body" id="prezzo-body">
            <div class="range-labels">
              <span id="minLabel">€0</span>
              <span id="maxLabel">€500</span>
            </div>
            <input type="range" id="prezzoMin" class="range-input" min="0" max="500" value="0"  step="5">
            <input type="range" id="prezzoMax" class="range-input" min="0" max="500" value="500" step="5">
          </div>
        </div>

        <%-- Marca --%>
        <div class="filter-group">
          <button type="button" class="filter-toggle" aria-expanded="true" data-target="marca-body">
            Marca <svg class="chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
          </button>
          <div class="filter-body" id="marca-body">
            <% if (marche != null) {
                for (String m : marche) { %>
              <label class="check-label">
                <input type="checkbox" class="filter-check" data-filter="marca" value="<%= m %>">
                <span class="checkmark"></span>
                <%= m %>
              </label>
            <% } } %>
          </div>
        </div>

        <%-- Taglia --%>
        <div class="filter-group">
          <button type="button" class="filter-toggle" aria-expanded="true" data-target="taglia-body">
            Taglia <svg class="chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
          </button>
          <div class="filter-body" id="taglia-body">
            <% if (taglie != null) {
                for (String t : taglie) { %>
              <label class="check-label">
                <input type="checkbox" class="filter-check" data-filter="taglia" value="<%= t %>">
                <span class="checkmark"></span>
                <%= t %>
              </label>
            <% } } %>
          </div>
        </div>

        <%-- Solo scontati --%>
        <div class="filter-group">
          <label class="check-label toggle-label">
            <input type="checkbox" id="filterSconto" class="filter-check" data-filter="sconto">
            <span class="checkmark"></span>
            Solo prodotti scontati
          </label>
        </div>
      </aside>

      <%-- AREA PRODOTTI --%>
      <section class="products-area">

        <%-- Ordinamento --%>
        <div class="sort-bar">
          <span class="sort-label">Ordina per</span>
          <select id="sortSelect" class="sort-select">
            <option value="default">In evidenza</option>
            <option value="prezzo-asc">Prezzo: dal più basso</option>
            <option value="prezzo-desc">Prezzo: dal più alto</option>
            <option value="sconto">Maggiore sconto</option>
            <option value="nome">Nome A–Z</option>
          </select>
        </div>

        <%-- ─── IN EVIDENZA ─── --%>
        <% if (!listaInEvidenza.isEmpty()) { %>
          <div class="section-block">
            <h2 class="section-label">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#2f8f3a" stroke-width="2.5"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
              In evidenza
            </h2>
            <div class="products-slider" id="gridEvidenza">
              <% for (Prodotto p : listaInEvidenza) { 
                  boolean haSconto = p.getSconto() > 0;
                  float prezzoFinale = haSconto ? (p.getPrezzo() - (p.getPrezzo() * p.getSconto() / 100)) : p.getPrezzo();
              %>
                <article class="product-card"
                         data-marca="<%= p.getMarca() %>"
                         data-prezzo="<%= prezzoFinale %>"
                         data-sconto="<%= haSconto ? "true" : "false" %>"
                         data-nome="<%= p.getNome() %>">
                  <a href="<%= request.getContextPath() %>/prodotto?id=<%= p.getId() %>" class="card-img-link">
                    <div class="card-img-wrap">
                      <% if (haSconto) { %>
                        <span class="card-badge badge-sale">-<%= p.getSconto() %>%</span>
                      <% } %>
                     <img src="<%= request.getContextPath() %>/images/prodotti/<%= imgDAO.doRetrieveByProductKey(p.getId()).get(0) %>"
                           alt="<%= p.getNome() %>" class="card-img" loading="lazy"
                           onerror="this.style.opacity=0">
                      <div class="card-img-placeholder" aria-hidden="true"></div>
                    </div>
                  </a>
                  <div class="card-body">
                    <span class="card-brand"><%= p.getMarca() %></span>
                    <h3 class="card-name">
                      <a href="<%= request.getContextPath() %>/prodotto?id=<%= p.getId() %>"><%= p.getNome() %></a>
                    </h3>
                    <div class="card-footer">
                      <% if (haSconto) { %>
                        <span class="card-price">€<%= String.format("%.2f", prezzoFinale) %></span>
                        <span class="card-price-orig">€<%= String.format("%.2f", p.getPrezzo()) %></span>
                      <% } else { %>
                        <span class="card-price">€<%= String.format("%.2f", p.getPrezzo()) %></span>
                      <% } %>
                      <a href="<%= request.getContextPath() %>/CarrelloServlet?action=aggiungi&id=<%= p.getId() %>"
                         class="card-cart-btn" aria-label="Aggiungi al carrello">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                          <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
                          <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
                        </svg>
                      </a>
                    </div>
                  </div>
                </article>
              <% } %>
            </div>
          </div>
        <% } %>

        <%-- ─── PIÙ SCONTATI ─── --%>
        <% if (!listaPiuScontati.isEmpty()) { %>
          <div class="section-block">
            <h2 class="section-label">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#c14a4a" stroke-width="2.5"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>
              Più scontati
            </h2>
            <div class="products-slider" id="gridScontati">
              <% for (Prodotto p : listaPiuScontati) { 
                  boolean haSconto = p.getSconto() > 0;
                  float prezzoFinale = haSconto ? (p.getPrezzo() - (p.getPrezzo() * p.getSconto() / 100)) : p.getPrezzo();
              %>
                <article class="product-card"
                         data-marca="<%= p.getMarca() %>"
                         data-prezzo="<%= prezzoFinale %>"
                         data-sconto="<%= haSconto ? "true" : "false" %>"
                         data-nome="<%= p.getNome() %>">
                  <a href="<%= request.getContextPath() %>/prodotto?id=<%= p.getId() %>" class="card-img-link">
                    <div class="card-img-wrap">
                      <% if (haSconto) { %>
                        <span class="card-badge badge-sale">-<%= p.getSconto() %>%</span>
                      <% } %>
                      <img src="<%= request.getContextPath() %>/images/prodotti/<%= imgDAO.doRetrieveByProductKey(p.getId()).get(0) %>"
                           alt="<%= p.getNome() %>" class="card-img" loading="lazy"
                           onerror="this.style.opacity=0">
                      <div class="card-img-placeholder" aria-hidden="true"></div>
                    </div>
                  </a>
                  <div class="card-body">
                    <span class="card-brand"><%= p.getMarca() %></span>
                    <h3 class="card-name">
                      <a href="<%= request.getContextPath() %>/prodotto?id=<%= p.getId() %>"><%= p.getNome() %></a>
                    </h3>
                    <div class="card-footer">
                      <% if (haSconto) { %>
                        <span class="card-price">€<%= String.format("%.2f", prezzoFinale) %></span>
                        <span class="card-price-orig">€<%= String.format("%.2f", p.getPrezzo()) %></span>
                      <% } else { %>
                        <span class="card-price">€<%= String.format("%.2f", p.getPrezzo()) %></span>
                      <% } %>
                      <a href="<%= request.getContextPath() %>/CarrelloServlet?action=aggiungi&id=<%= p.getId() %>"
                         class="card-cart-btn" aria-label="Aggiungi al carrello">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                          <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
                          <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
                        </svg>
                      </a>
                    </div>
                  </div>
                </article>
              <% } %>
            </div>
          </div>
        <% } %>

        <%-- ─── TUTTI I PRODOTTI ─── --%>
        <div class="section-block">
          <h2 class="section-label">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
            Tutti i prodotti
          </h2>
          <div class="products-grid" id="gridTutti">
            <% if (!listaProdotti.isEmpty()) { 
                for (Prodotto p : listaProdotti) { 
                  boolean haSconto = p.getSconto() > 0;
                  float prezzoFinale = haSconto ? (p.getPrezzo() - (p.getPrezzo() * p.getSconto() / 100)) : p.getPrezzo();
            %>
              <article class="product-card"
                       data-marca="<%= p.getMarca() %>"
                       data-prezzo="<%= prezzoFinale %>"
                       data-sconto="<%= haSconto ? "true" : "false" %>"
                       data-nome="<%= p.getNome() %>">
                <a href="<%= request.getContextPath() %>/prodotto?id=<%= p.getId() %>" class="card-img-link">
                  <div class="card-img-wrap">
                    <% if (haSconto) { %>
                      <span class="card-badge badge-sale">-<%= p.getSconto() %>%</span>
                    <% } %>
                     <img src="<%= request.getContextPath() %>/images/prodotti/<%= imgDAO.doRetrieveByProductKey(p.getId()).get(0) %>"
                         alt="<%= p.getNome() %>" class="card-img" loading="lazy"
                         onerror="this.style.opacity=0">
                    <div class="card-img-placeholder" aria-hidden="true"></div>
                  </div>
                </a>
                <div class="card-body">
                  <span class="card-brand"><%= p.getMarca() %></span>
                  <h3 class="card-name">
                    <a href="<%= request.getContextPath() %>/prodotto?id=<%= p.getId() %>"><%= p.getNome() %></a>
                  </h3>
                  <div class="card-footer">
                    <% if (haSconto) { %>
                      <span class="card-price">€<%= String.format("%.2f", prezzoFinale) %></span>
                      <span class="card-price-orig">€<%= String.format("%.2f", p.getPrezzo()) %></span>
                    <% } else { %>
                      <span class="card-price">€<%= String.format("%.2f", p.getPrezzo()) %></span>
                    <% } %>
                    <a href="<%= request.getContextPath() %>/CarrelloServlet?action=aggiungi&id=<%= p.getId() %>"
                       class="card-cart-btn" aria-label="Aggiungi al carrello">
                      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
                        <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
                      </svg>
                    </a>
                  </div>
                </div>
              </article>
            <% } } %>
          </div>

          <%-- Messaggio vuoto --%>
          <div class="empty-msg" id="emptyMsg" hidden>
            <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#444" stroke-width="1.5"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <p>Nessun prodotto corrisponde ai filtri selezionati.</p>
            <button type="button" class="reset-btn" onclick="document.getElementById('resetBtn').click()">Azzera filtri</button>
          </div>
        </div>

      </section>
    </div>
  </main>

  <%@ include file="/WEB-INF/view/parziali/footer.jsp" %>

  <script src="<%= request.getContextPath() %>/js/catalogo.js"></script>
</body>
</html>