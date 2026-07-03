<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%@ page import="model.Ordine" %>
<%@ page import="model.RigaOrdine" %>
<%@ page import="model.Prodotto" %>
<%@ page import="daoImpl.OrdineDAOImpl" %>
<%@ page import="daoImpl.RigaOrdineDAOImpl" %>
<%@ page import="daoImpl.ProdottoDAOImpl" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
  // Se non loggato rimanda al login tramite la NavigationServlet
  if (session.getAttribute("utente") == null) {
      response.sendRedirect(request.getContextPath() + "/view/login");
      return;
  }
  // Recupera i dati dell'utente dalla sessione
  Utente user = (Utente) session.getAttribute("utente");

  boolean editMode = request.getAttribute("editMode") != null;
  Object erroreAttr = request.getAttribute("errore");

  String nomeVal = request.getAttribute("nomeInserito") != null ? (String) request.getAttribute("nomeInserito") : user.getNome();
  String cognomeVal = request.getAttribute("cognomeInserito") != null ? (String) request.getAttribute("cognomeInserito") : user.getCognome();
  String indirizzoVal = request.getAttribute("indirizzoInserito") != null ? (String) request.getAttribute("indirizzoInserito") : user.getIndirizzo();
  String provinciaVal = request.getAttribute("provinciaInserita") != null ? (String) request.getAttribute("provinciaInserita") : user.getProvincia();
  String paeseVal = request.getAttribute("paeseInserito") != null ? (String) request.getAttribute("paeseInserito") : user.getPaese();

  // Storico ordini dell'utente loggato
  OrdineDAOImpl ordineDAO = new OrdineDAOImpl();
  RigaOrdineDAOImpl rigaOrdineDAO = new RigaOrdineDAOImpl();
  ProdottoDAOImpl prodottoDAOStorico = new ProdottoDAOImpl();
  List<Ordine> ordini = new ArrayList<Ordine>();
  try {
      ordini = ordineDAO.doRetrieveByUtente(user.getId());
  } catch (Exception e) {
      e.printStackTrace();
  }
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Kick Off — Profilo</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=Barlow:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/auth.css">
</head>
<body>

  <div class="auth-page">

    <div class="field--background">
      <div class="center-line"></div>
      <div class="center-circle"></div>
      <div class="penalty-box top"></div>
      <div class="penalty-box bottom"></div>
      <div class="goal-box top"></div>
      <div class="goal-box bottom"></div>
      <div class="penalty-spot top"></div>
      <div class="penalty-spot bottom"></div>
    </div>

    <header style="position: absolute; top: 0; left: 0; z-index: 10;">
      <nav class="nav-left">
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=MAGLIE">Maglie</a>
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=COMPLETO">Completi</a>
    </nav>

    <a href="<%= request.getContextPath() %>/" class="logo-link">
      <img src="../images/logo.png" alt="Kick Off Logo">
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

    <div class="auth-wrapper" style="margin-top: 90px;">
      <div class="auth-card profilo-card">

        <div class="profilo-avatar">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
          </svg>
        </div>

        <h1 class="auth-title">Il tuo profilo</h1>

        <% if ("ok".equals(request.getParameter("ordine"))) { %>
          <div class="profilo-success">Ordine effettuato con successo! Grazie per il tuo acquisto.</div>
        <% } %>

        <% if (erroreAttr != null) { %>
          <div class="auth-error">
            <% if (erroreAttr instanceof List) { %>
              <ul style="margin: 0; padding-left: 18px;">
                <% for (String err : (List<String>) erroreAttr) { %>
                  <li><%= err %></li>
                <% } %>
              </ul>
            <% } else { %>
              <%= erroreAttr %>
            <% } %>
          </div>
        <% } %>

        <div class="profilo-info" id="profiloInfo" <% if (editMode) { %>style="display:none;"<% } %>>
          <div class="profilo-row">
            <span class="profilo-label">Nome e Cognome</span>
            <span class="profilo-value"><%= user.getNome() + " " + user.getCognome() %></span>
          </div>
          <div class="profilo-row">
            <span class="profilo-label">Email: </span>
            <span class="profilo-value"><%= user.getEmail() %></span>
          </div>
          <div class="profilo-row">
            <span class="profilo-label">Indirizzo: </span>
            <span class="profilo-value"><%= user.getIndirizzo() + ", " + user.getProvincia() + " (" + user.getPaese() + ")" %></span>
          </div>
        </div>

        <form id="modificaProfiloForm" class="auth-form profilo-edit-form" action="${pageContext.request.contextPath}/ModificaProfilo" method="post"
              <% if (!editMode) { %>style="display:none;"<% } %>>

          <div class="form-row">
            <div class="form-group">
              <label for="nome">Nome</label>
              <input type="text" id="nome" name="nome" value="<%= nomeVal %>" required autocomplete="given-name">
            </div>
            <div class="form-group">
              <label for="cognome">Cognome</label>
              <input type="text" id="cognome" name="cognome" value="<%= cognomeVal %>" required autocomplete="family-name">
            </div>
          </div>

          <div class="form-group">
            <label for="indirizzo">Indirizzo</label>
            <input type="text" id="indirizzo" name="indirizzo" value="<%= indirizzoVal %>" required>
          </div>

          <div class="form-row">
            <div class="form-group row-paese">
              <label for="paese">Paese</label>
              <input type="text" id="paese" name="paese" value="<%= paeseVal %>" required>
            </div>
            <div class="form-group row-provincia">
              <label for="provincia">Prov.</label>
              <input type="text" id="provincia" name="provincia" value="<%= provinciaVal %>" required size="2" maxlength="2">
            </div>
          </div>

          <div class="profilo-actions-row">
            <button type="submit" class="btn-auth">Salva modifiche</button>
            <button type="button" class="btn-secondary" id="annullaModificaBtn">Annulla</button>
          </div>
        </form>

        <div class="profilo-actions" id="profiloActions" style="margin-top: 24px; <% if (editMode) { %>display:none;<% } %>">
          <button type="button" class="btn-secondary" id="modificaProfiloBtn">Modifica informazioni</button>
          <a href="${pageContext.request.contextPath}/view/client/assistenzaClienti" class="btn-secondary">Contatta Assistenza</a>
          <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-logout">Esci dall'account</a>
        </div>

      </div>
    </div>

    <div class="ordini-wrapper">
      <h2 class="ordini-title">I tuoi ordini</h2>

      <% if (ordini.isEmpty()) { %>
        <p class="ordini-vuoto">Non hai ancora effettuato ordini.</p>
      <% } else {
           for (Ordine o : ordini) {
               String classeStato = "badge-elaborazione";
               if (o.getStato() == model.Stato.SPEDITO) classeStato = "badge-spedito";
               if (o.getStato() == model.Stato.IN_CONSEGNA) classeStato = "badge-consegna";
               if (o.getStato() == model.Stato.CONSEGNATO) classeStato = "badge-consegnato";

               List<RigaOrdine> righe = new ArrayList<RigaOrdine>();
               try {
                   righe = rigaOrdineDAO.doRetrieveByOrdine(o.getId());
               } catch (Exception e) {
                   e.printStackTrace();
               }
      %>
        <div class="ordine-card">
          <div class="ordine-header">
            <span class="ordine-id">Ordine #<%= o.getId() %></span>
            <span class="ordine-data"><%= o.getData() %></span>
            <span class="order-status-badge <%= classeStato %>"><%= o.getStato().name() %></span>
            <span class="ordine-totale">€<%= String.format("%.2f", o.getTotale()) %></span>
          </div>
          <ul class="ordine-righe">
            <% for (RigaOrdine r : righe) {
                 Prodotto p = prodottoDAOStorico.doRetrieveByKey(r.getProdottoId());
                 String nomeProdotto = (p != null) ? p.getNome() : "Prodotto non piu disponibile";
            %>
              <li><span class="riga-nome"><%= nomeProdotto %><% if (r.getTaglia() != null && !r.getTaglia().isEmpty()) { %> (taglia <%= r.getTaglia() %>)<% } %> × <%= r.getQuantita() %></span> <span class="riga-prezzo">€<%= String.format("%.2f", r.getPrezzo() * r.getQuantita()) %></span></li>
            <% } %>
          </ul>
        </div>
      <% } } %>
    </div>

  </div>

  <script src="${pageContext.request.contextPath}/scripts/profilo.js"></script>
</body>
</html>
