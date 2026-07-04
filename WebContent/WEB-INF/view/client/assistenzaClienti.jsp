<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Chat" %>
<%@ page import="model.Messaggio" %>
<%@ page import="model.Utente" %>
<%@ page import="dao.ChatDAO" %>
<%@ page import="daoImpl.ChatDAOImpl" %>
<%@ page import="dao.MessaggioDAO" %>
<%@ page import="daoImpl.MessaggioDAOImpl" %>
<%
  if (session.getAttribute("utente") == null) {
      response.sendRedirect(request.getContextPath() + "/view/login");
      return;
  }
  Utente user = (Utente) session.getAttribute("utente");

  ChatDAO chatDao = new ChatDAOImpl();
  MessaggioDAO msgDao = new MessaggioDAOImpl();

  Chat miaChat = null;
  ArrayList<Messaggio> cronologiaMessaggi = null;

  try {
      miaChat = chatDao.doRetrieveByCliente(user.getId());
      if (miaChat != null) {
          cronologiaMessaggi = msgDao.doRetrieveByChat(miaChat.getId());
      }
  } catch (Exception e) {
      e.printStackTrace();
      request.setAttribute("errore", "Errore nel caricamento del servizio di assistenza.");
  }
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Kick Off — Assistenza Clienti</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=Barlow:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/base.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/carrello.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/assistenza.css">
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
      <a href="<%= request.getContextPath() %>/view/profilo" class="icon-link icon-link--active" aria-label="Profilo">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
          <circle cx="12" cy="7" r="4"/>
        </svg>
      </a>
    </nav>
  </header>

  <main class="carrello-main assistenza-main">
    <h1 class="carrello-title">Assistenza Clienti</h1>

    <% if (request.getAttribute("errore") != null) { %>
      <div class="auth-error"><%= request.getAttribute("errore") %></div>
    <% } %>

    <% if (miaChat == null) { %>
      <%-- Nessun ticket aperto: form per iniziarne uno nuovo --%>
      <form id="nuovoTicketForm" class="nuovo-ticket-form" action="<%= request.getContextPath() %>/IniziaChat" method="post">
        <p style="color:#888; font-size:13px; margin:0;">
          Non hai richieste di assistenza aperte. Scrivici un messaggio e ti risponderemo il prima possibile.
        </p>
        <textarea name="testoMessaggio" placeholder="Descrivi il tuo problema..." required></textarea>
        <button type="submit" class="btn-invia" style="align-self: flex-end;">Invia richiesta</button>
      </form>
    <% } else { %>
      <%-- Ticket aperto: cronologia stile WhatsApp --%>
      <div class="assistenza-panel">
        <div class="assistenza-panel-header">
          <div class="assistenza-panel-info">
            <h4>Assistenza Kick Off</h4>
            <span class="assistenza-status"><span class="status-dot"></span>Ticket #<%= miaChat.getId() %> aperto il <%= miaChat.getDataCreazione() %></span>
          </div>
        </div>
        <div class="wa-body" id="waBody">
          <% if (cronologiaMessaggi != null && !cronologiaMessaggi.isEmpty()) {
               for (Messaggio m : cronologiaMessaggi) {
                   boolean isMio = (m.getMittente() == user.getId());
          %>
            <div class="msg-bubble <%= isMio ? "msg-mine" : "msg-support" %>">
              <%= m.getTesto() %>
              <span class="msg-time"><%= m.getDataInvio() %></span>
            </div>
          <% }
             } else { %>
            <div class="assistenza-empty">
              <p style="font-size: 13px;">Richiesta ricevuta. Un operatore ti risponderà a breve.</p>
            </div>
          <% } %>
        </div>

        <form id="rispondiForm" class="wa-form" action="<%= request.getContextPath() %>/InviaMessaggioCliente" method="post">
          <input type="hidden" name="chatId" value="<%= miaChat.getId() %>">
          <input type="text" name="testoMessaggio" class="wa-input" placeholder="Scrivi un messaggio..." required autocomplete="off">
          <button type="submit" class="btn-invia">Invia</button>
        </form>
      </div>
    <% } %>
  </main>

  <%@ include file="/WEB-INF/view/parziali/footer.jsp" %>

  <script src="<%= request.getContextPath() %>/scripts/assistenzaClienti.js"></script>
</body>
</html>
