<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Prodotto" %>
<%@ page import="model.ItemCarrello" %>
<%@ page import="model.Utente" %>
<%
  // Se non loggato rimanda al login, se il carrello e' vuoto rimanda al carrello
  if (session.getAttribute("utente") == null) {
      response.sendRedirect(request.getContextPath() + "/view/login?redirect=checkout");
      return;
  }
  Utente user = (Utente) session.getAttribute("utente");

  List<ItemCarrello> carrello = (List<ItemCarrello>) session.getAttribute("carrello");
  if (carrello == null) carrello = new ArrayList<ItemCarrello>();
  if (carrello.isEmpty()) {
      response.sendRedirect(request.getContextPath() + "/view/carrello");
      return;
  }

  // Calcolo dei totali (stessa logica di carrello.jsp)
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

  totaleRisparmiato = totaleProdotti - totaleScontato;

  float sogliaSpedizione = 80.00f;
  float speseSpedizione = (totaleScontato >= sogliaSpedizione) ? 0.00f : 4.99f;
  float totaleCompleto = totaleScontato + speseSpedizione;

  // Ripopolamento campi in caso di errore di validazione
  String indirizzoVal = request.getAttribute("indirizzoInserito") != null ? (String) request.getAttribute("indirizzoInserito") : user.getIndirizzo();
  String provinciaVal = request.getAttribute("provinciaInserita") != null ? (String) request.getAttribute("provinciaInserita") : user.getProvincia();
  String paeseVal = request.getAttribute("paeseInserito") != null ? (String) request.getAttribute("paeseInserito") : user.getPaese();
  String titolareVal = request.getAttribute("titolareInserito") != null ? (String) request.getAttribute("titolareInserito") : (user.getNome() + " " + user.getCognome());
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Checkout — Kick Off</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Barlow:wght@400;600;700;800&family=Barlow+Condensed:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/base.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/auth.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/carrello.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/checkout.css">
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
      <a href="<%= request.getContextPath() %>/view/carrello" class="icon-link" aria-label="Carrello">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
          <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
        </svg>
      </a>
      <a href="<%= request.getContextPath() %>/view/profilo" class="icon-link icon-link--active" aria-label="Profilo">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
          <circle cx="12" cy="7" r="4"/>
        </svg>
      </a>
    </nav>
  </header>

  <main class="carrello-main">
    <h1 class="carrello-title">Checkout</h1>

    <% if (request.getAttribute("errore") != null) { %>
      <div class="auth-error">
        <ul style="margin: 0; padding-left: 18px;">
          <% for (String err : (List<String>) request.getAttribute("errore")) { %>
            <li><%= err %></li>
          <% } %>
        </ul>
      </div>
    <% } %>

    <div class="carrello-layout">

      <%-- ── FORM SPEDIZIONE + PAGAMENTO ── --%>
      <div class="checkout-form-wrap">
        <form id="checkoutForm" class="auth-form" action="<%= request.getContextPath() %>/CheckoutServlet" method="post" novalidate>

          <div class="checkout-card">
            <h2 class="checkout-section-title">Indirizzo di spedizione</h2>

            <div class="form-group">
              <label for="indirizzo">Indirizzo</label>
              <input type="text" id="indirizzo" name="indirizzo" value="<%= indirizzoVal %>" placeholder="Via Roma 1" required>
            </div>

            <div class="form-row">
              <div class="form-group row-paese">
                <label for="paese">Paese</label>
                <input type="text" id="paese" name="paese" value="<%= paeseVal %>" placeholder="Italia" required>
              </div>
              <div class="form-group row-provincia">
                <label for="provincia">Prov.</label>
                <input type="text" id="provincia" name="provincia" value="<%= provinciaVal %>" placeholder="NA" required size="2" maxlength="2">
              </div>
            </div>
          </div>

          <div class="checkout-card">
            <h2 class="checkout-section-title">Dati di pagamento</h2>
            <p class="checkout-fake-notice">Sito dimostrativo: nessuna transazione reale viene effettuata.</p>

            <div class="form-group">
              <label for="titolare">Titolare della carta</label>
              <input type="text" id="titolare" name="titolare" value="<%= titolareVal %>" placeholder="Mario Rossi" required autocomplete="cc-name">
            </div>

            <div class="form-group">
              <label for="numeroCarta">Numero carta</label>
              <input type="text" id="numeroCarta" name="numeroCarta" placeholder="1234 5678 9012 3456" required autocomplete="cc-number" inputmode="numeric">
            </div>

            <div class="form-row">
              <div class="form-group">
                <label for="scadenza">Scadenza (MM/AA)</label>
                <input type="text" id="scadenza" name="scadenza" placeholder="MM/AA" required autocomplete="cc-exp">
              </div>
              <div class="form-group row-provincia">
                <label for="cvv">CVV</label>
                <input type="text" id="cvv" name="cvv" placeholder="123" required autocomplete="cc-csc" inputmode="numeric" maxlength="4">
              </div>
            </div>
          </div>

          <button type="submit" class="btn-checkout">
            Conferma e Paga — €<%= String.format("%.2f", totaleCompleto) %>
          </button>
        </form>
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

          <div class="summary-divider"></div>

          <div class="summary-row totale-row">
            <span>Totale</span>
            <span>€<%= String.format("%.2f", totaleCompleto) %></span>
          </div>

          <a href="<%= request.getContextPath() %>/view/carrello" class="btn-continue">← Torna al carrello</a>
        </div>
      </aside>

    </div>
  </main>

  <%@ include file="/WEB-INF/view/parziali/footer.jsp" %>

  <script src="<%= request.getContextPath() %>/scripts/checkout.js"></script>
</body>
</html>
