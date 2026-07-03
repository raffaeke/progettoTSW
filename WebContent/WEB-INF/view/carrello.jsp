<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="daoImpl.ImgDAOImpl" %>
<%@ page import="model.Prodotto" %>
<%@ page import="model.Spec_prodotto" %>
<%@ page import="model.ItemCarrello" %>
<%
  // Recuperiamo il carrello dalla sessione
  List<ItemCarrello> carrello = (List<ItemCarrello>) session.getAttribute("carrello");
  if (carrello == null) {
      carrello = new ArrayList<ItemCarrello>();
  }

  // Calcolo dei totali direttamente nel blocco Java iniziale
  float totaleProdotti = 0;
  float totaleScontato = 0;
  float totaleRisparmiato = 0;

  for (ItemCarrello item : carrello) {
      Prodotto prod = item.getP();
      if (prod != null) {
          int qta = item.getQuantita();
          float prezzoOriginale = prod.getPrezzo() * qta;
          totaleProdotti += prezzoOriginale;
          
          if (prod.getSconto() > 0) {
              float prezzoScontatoUnitario = prod.getPrezzo() - (prod.getPrezzo() * prod.getSconto() / 100);
              totaleScontato += (prezzoScontatoUnitario * qta);
          } else {
              totaleScontato += prezzoOriginale;
          }
      }
  }
  
  // Inizializzazione DAO Immagini
  ImgDAOImpl imgDAO = new ImgDAOImpl();
  
  totaleRisparmiato = totaleProdotti - totaleScontato;

  // Spedizione gratuita sopra gli 80€ (Coerente con la politica del sito)
  float sogliaSpedizione = 80.00f;
  float speseSpedizione = (totaleScontato >= sogliaSpedizione || carrello.isEmpty()) ? 0.00f : 4.99f;
  float totaleCompleto = totaleScontato + speseSpedizione;
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Il tuo Carrello — Kick Off</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Barlow:wght@400;600;700;800&family=Barlow+Condensed:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/base.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/carrello.css">
</head>

<body data-ctx="<%= request.getContextPath() %>">

  <%-- ===== HEADER ===== --%>
  <header class="main-header">
    <nav class="nav-left">
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=MAGLIE">Maglie</a>
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=COMPLETI">Completi</a>
    </nav>
    <a href="<%= request.getContextPath() %>/" class="logo-link">
      <img src="<%= request.getContextPath() %>/images/logo.png" alt="Kick Off">
    </a>
    <nav class="nav-right">
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=GUANTONI">Guantoni</a>
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=SCARPE">Scarpette</a>
      <a href="<%= request.getContextPath() %>/view/carrello" class="icon-link icon-link--active" aria-label="Carrello">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
          <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
        </svg>
      </a>
      <% if (session.getAttribute("utente") != null) { %>
        <a href="<%= request.getContextPath() %>/view/profilo" class="icon-link" aria-label="Profilo">
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

  <main class="carrello-main">
    <h1 class="carrello-title">Il tuo Carrello</h1>

    <% if (!carrello.isEmpty()) { %>
      <div class="carrello-layout">
        
        <%-- ── LISTA ELEMENTI CARRELLO ── --%>
        <div class="carrello-items">
          <% 
            for (ItemCarrello item : carrello) {
              Prodotto prod = item.getP();
              Spec_prodotto spec = item.getSpec();
              if (prod != null && spec != null) {
                  boolean haSconto = prod.getSconto() > 0;
                  float prezzoUnitario = haSconto ? (prod.getPrezzo() - (prod.getPrezzo() * prod.getSconto() / 100)) : prod.getPrezzo();
                  
                  // Recupero dinamico dell'immagine di copertina (la prima della lista)
                  List<String> immagini = imgDAO.doRetrieveByProductKey(prod.getId());
                  String imgPath = (immagini != null && !immagini.isEmpty()) ? immagini.get(0) : "";
                  
                  // Gestione flessibile se nel DB salvi solo il nome del file (es. "scarpa1") o l'estensione inclusa
                  if(!imgPath.toLowerCase().endsWith(".jpg") && !imgPath.toLowerCase().endsWith(".png") && !imgPath.isEmpty()) {
                      imgPath += ".jpg";
                  }
          %>
            <article class="carrello-card" data-spec-id="<%= spec.getId() %>">
              <div class="cart-img-wrap">
                <% if(!imgPath.isEmpty()) { %>
                  <img src="<%= request.getContextPath() %>/images/prodotti/<%= imgPath %>" alt="<%= prod.getNome() %>" onerror="this.src='<%= request.getContextPath() %>/images/logo.png'">
                <% } else { %>
                  <img src="<%= request.getContextPath() %>/images/logo.png" alt="Kick Off Placeholder">
                <% } %>
              </div>
              
              <div class="cart-info-wrap">
                <div class="cart-details">
                  <span class="cart-marca"><%= prod.getMarca() %></span>
                  <h2 class="cart-nome">
                    <a href="<%= request.getContextPath() %>/prodotto?id=<%= prod.getId() %>"><%= prod.getNome() %></a>
                  </h2>
                  <p class="cart-meta">Categoria: <strong><%= prod.getCat() %></strong> · Taglia: <strong><%= spec.getTaglia() %></strong></p>
                </div>

                <%-- Controllo Quantità --%>
                <div class="cart-qty-control">
                  <form action="<%= request.getContextPath() %>/CarrelloServlet" method="post" class="qty-form">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="specId" value="<%= spec.getId() %>">
                    <label for="qty-<%= spec.getId() %>" class="sr-only">Quantità</label>
                    <input type="number" id="qty-<%= spec.getId() %>" name="quantita" value="<%= item.getQuantita() %>" min="1" max="<%= spec.getQuantita() %>" onchange="this.form.submit()" class="qty-input">
                  </form>

                  <form action="<%= request.getContextPath() %>/CarrelloServlet" method="post" class="remove-form">
                    <input type="hidden" name="action" value="remove">
                    <input type="hidden" name="specId" value="<%= spec.getId() %>">
                    <button type="submit" class="btn-remove" aria-label="Rimuovi <%= prod.getNome() %>">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
                      Rimuovi
                    </button>
                  </form>
                </div>
                
                <%-- Prezzi dell'Item --%>
                <div class="cart-price-wrap">
                  <% if (haSconto) { %>
                    <span class="cart-prezzo-attuale">€<%= String.format("%.2f", prezzoUnitario * item.getQuantita()) %></span>
                    <span class="cart-prezzo-originale">€<%= String.format("%.2f", prod.getPrezzo() * item.getQuantita()) %></span>
                  <% } else { %>
                    <span class="cart-prezzo-attuale">€<%= String.format("%.2f", prod.getPrezzo() * item.getQuantita()) %></span>
                  <% } %>
                </div>
              </div>
            </article>
          <% } } %>
        </div>

        <%-- ── RIEPILOGO ORDINE (SIDEBAR) ── --%>
        <aside class="carrello-summary">
          <div class="summary-card">
            <h2 class="summary-title">Riepilogo Ordine</h2>
            
            <div class="summary-row">
              <span>Prezzo originale</span>
              <span>€<%= String.format("%.2f", totaleProdotti) %></span>
            </div>
            
            <% if (totaleRisparmiato > 0) { %>
              <div class="summary-row sconto-row">
                <span>Sconto Kick Off</span>
                <span>-€<%= String.format("%.2f", totaleRisparmiato) %></span>
              </div>
            <% } %>
            
            <div class="summary-row">
              <span>Spedizione</span>
              <% if (speseSpedizione == 0.00f) { %>
                <span class="sped-gratis">Gratis</span>
              <% } else { %>
                <span>€<%= String.format("%.2f", speseSpedizione) %></span>
              <% } %>
            </div>
            
            <% if (speseSpedizione > 0) { %>
              <p class="sped-avviso-mancante">
                Aggiungi <strong>€<%= String.format("%.2f", sogliaSpedizione - totaleScontato) %></strong> per sbloccare la spedizione gratuita!
              </p>
            <% } %>
            
            <div class="summary-divider"></div>
            
            <div class="summary-row totale-row">
              <span>Totale</span>
              <span>€<%= String.format("%.2f", totaleCompleto) %></span>
            </div>
            
            <%-- Il checkout richiede un account: agli ospiti mostriamo un CTA verso il login invece del bottone --%>
            <% if (session.getAttribute("utente") != null) { %>
              <a href="<%= request.getContextPath() %>/view/client/checkout" class="btn-checkout">
                Procedi al Checkout
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
              </a>
            <% } else { %>
              <p class="checkout-login-notice">Accedi al tuo account per completare l'acquisto.</p>
              <a href="<%= request.getContextPath() %>/view/login?redirect=checkout" class="btn-checkout">
                Accedi per continuare
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
              </a>
            <% } %>
            
            <a href="<%= request.getContextPath() %>/" class="btn-continue">Continua lo shopping</a>
          </div>
        </aside>

      </div>
    <% } else { %>
      <%-- Carrello Vuoto --%>
      <div class="carrello-empty">
        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
        <p>Il tuo carrello è attualmente vuoto.</p>
        <%-- btn-primary per richiamare i bottoni verdi generali delle altre pagine --%>
        <a href="<%= request.getContextPath() %>/" class="btn-primary">Scopri il Catalogo</a>
      </div>
    <% } %>
  </main>

  <%@ include file="/WEB-INF/view/parziali/footer.jsp" %>

</body>
</html>