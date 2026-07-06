<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Ordine" %>
<%@ page import="daoImpl.OrdineDAOImpl" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Stato" %>
<%
  // 1. Sicurezza lato codice per l'admin
  Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
  if (session.getAttribute("utente") == null || isAdmin == null || !isAdmin) {
      response.sendRedirect(request.getContextPath() + "/view/login");
      return;
  }

  // 2. Chiamata diretta al DB per lo storico ordini
  OrdineDAOImpl ordineDao = new OrdineDAOImpl();
  ArrayList<Ordine> listaOrdini = null;
  try {
      listaOrdini = ordineDao.doRetrieveAll(); // Recupera tutti gli ordini del sito
  } catch(Exception e) {
      request.setAttribute("errore", "Impossibile caricare lo storico ordini dal database.");
  }
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Kick Off — Storico Ordini</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=Barlow:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/auth.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/admin.css"> 
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

    <header style="position: absolute; top: 0; left: 0; z-index: 10; width: 100%;">
      <div class="nav-left">
        <a href="${pageContext.request.contextPath}/view/admin/dashboard" class="admin-badge" style="text-decoration: none;">← TORNA ALLA DASHBOARD</a>
      </div>
      <a href="${pageContext.request.contextPath}/view/admin/dashboard" class="logo-link">
        <img src="${pageContext.request.contextPath}/images/logo.png" alt="Kick Off Logo">
      </a>
      <div class="nav-right">
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-admin-logout">Esci</a>
      </div>
    </header>

    <main class="admin-container" style="position: relative; z-index: 2; padding-top: 130px; padding-bottom: 40px; max-width: 1100px;">
      
      <% if (request.getAttribute("errore") != null) { %>
        <div class="auth-error" style="margin-bottom: 20px;"><%= request.getAttribute("errore") %></div>
      <% } %>

      <div class="admin-glass-panel" style="width: 100%;">
        <h2>Storico Generale Ordini</h2>
        
        <div class="table-wrapper">
          <table class="admin-table">
            <thead>
              <tr>
                <th>ID Ordine</th>
                <th>ID Utente</th>
                <th>Totale Speso</th>
                <th>Stato Spedizione</th>
                <th style="text-align: center;">Azioni</th>
              </tr>
            </thead>
            <tbody>
              <% 
                if (listaOrdini != null && !listaOrdini.isEmpty()) {
                  for(Ordine ordine : listaOrdini) {
                      Stato stato = ordine.getStato() != null ? ordine.getStato() : Stato.IN_ELABORAZIONE;
                      
                      // Assegna una classe CSS dinamica in base allo stato dell'ordine
                      String classeStato = "badge-elaborazione";
                      if(stato == Stato.SPEDITO) classeStato = "badge-spedito";
                      if(stato == Stato.IN_CONSEGNA) classeStato = "badge-consegna";
                      if(stato == Stato.CONSEGNATO) classeStato = "badge-consegnato";
              %>
                <tr>
                  <td><span class="td-id">#ORD-<%= ordine.getId() %></span></td>
                  <td><span class="user-id-tag">User #<%= ordine.getUtenteId() %></span></td>
                  <td><span class="td-price" style="color: #17b978;"><%= String.format("%.2f", ordine.getTotale()) %>€</span></td>
                  <td>
  						<span class="order-status-badge <%= classeStato %>">
    					<%= stato.name() %>
  						</span>
				  </td>
                  <td>
                    <form action="${pageContext.request.contextPath}/GestioneOrdini" method="post" style="display: flex; gap: 6px; justify-content: center; align-items: center;">
                      <input type="hidden" name="ordineId" value="<%= ordine.getId() %>">
                      <select name="nuovoStato" class="admin-select" style="padding: 5px 10px; font-size: 11px; width: auto; background: rgba(0,0,0,0.4);">
                        <option value="IN_ELABORAZIONE" <%= stato.equals(Stato.IN_ELABORAZIONE)?"selected":"" %>>ELABORA</option>
                        <option value="SPEDITO" <%= stato.equals(Stato.SPEDITO)?"selected":"" %>>SPEDISCI</option>
                        <option value="IN_CONSEGNA" <%= stato.equals(Stato.IN_CONSEGNA)?"selected":"" %>>IN CONSEGNA</option>
                        <option value="CONSEGNATO" <%= stato.equals(Stato.CONSEGNATO)?"selected":"" %>>CONSEGNATO</option>
                      </select>
                      <button type="submit" class="btn-action-edit" style="cursor: pointer; padding: 6px 10px;">Aggiorna</button>
                    </form>
                  </td>
                </tr>
              <% 
                  }
                } else { 
              %>
                <tr>
                  <td colspan="5" style="text-align: center; color: #888; padding: 50px;">Nessun ordine effettuato sulla piattaforma fino ad ora.</td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </main>

  </div>

</body>
</html>