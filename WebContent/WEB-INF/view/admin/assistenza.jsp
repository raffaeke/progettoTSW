<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Chat" %>
<%@ page import="model.Messaggio" %>
<%@ page import="dao.ChatDAO" %>
<%@ page import="daoImpl.ChatDAOImpl" %>
<%@ page import="dao.MessaggioDAO" %>
<%@ page import="daoImpl.MessaggioDAOImpl" %>
<%
  // 1. Controllo di Sicurezza per l'Amministratore
  Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
  if (session.getAttribute("utente") == null || isAdmin == null || !isAdmin) {
      response.sendRedirect(request.getContextPath() + "/view/login");
      return;
  }
  
  //permette di non accedere alla pagina tramite cache o proxy
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
  response.setHeader("Pragma", "no-cache"); // HTTP 1.0
  response.setDateHeader("Expires", 0); // Proxy

  // 2. Inizializzazione DAO e Variabili
  ChatDAO chatDao = new ChatDAOImpl();
  MessaggioDAO msgDao = new MessaggioDAOImpl();
  
  ArrayList<Chat> listaChat = null;
  ArrayList<Messaggio> cronologiaMessaggi = null;
  Chat chatSelezionata = null;
  
  String idChatParam = request.getParameter("idChat");
  
  try {
      listaChat = chatDao.doRetrieveAll(); // Elenco di tutte le chat nella colonna sinistra
      
      // Se l'URL contiene un ID chat valido, carichiamo la conversazione per la colonna destra
      if (idChatParam != null && !idChatParam.isEmpty()) {
          int idChat = Integer.parseInt(idChatParam);
          cronologiaMessaggi = msgDao.doRetrieveByChat(idChat);
          chatSelezionata = chatDao.doRetrieveByKey(idChat);
      }
  } catch(Exception e) {
      e.printStackTrace();
      request.setAttribute("errore", "Errore nel caricamento del servizio di assistenza: " + e.toString());
  }
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Kick Off — Centro Assistenza Clienti</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=Barlow:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/auth.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/admin.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/assistenza.css">
</head>
<body>

  <div class="auth-page">
    
    <div class="field--background">
      <div class="center-line"></div>
      <div class="center-circle"></div>
      <div class="penalty-box top"></div>
      <div class="penalty-box bottom"></div>
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

    <main class="split-container">
      
      <div class="admin-glass-panel inbox-panel">
        <h3 style="margin-bottom: 15px; color: #17b978; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">
          Ticket Assistenza
        </h3>
        
        <% if (request.getAttribute("errore") != null) { %>
          <div class="auth-error" style="margin-bottom: 15px; font-size: 12px;"><%= request.getAttribute("errore") %></div>
        <% } %>
        
        <div class="inbox-list">
          <% 
            if (listaChat != null && !listaChat.isEmpty()) {
              for (Chat c : listaChat) {
                  boolean isSelezionata = (chatSelezionata != null && chatSelezionata.getId() == c.getId());
          %>
            <a href="?idChat=<%= c.getId() %>&t=<%= System.currentTimeMillis() %>" style="text-decoration: none; color: inherit;">
              <div class="inbox-card" style="background: <%= isSelezionata ? "rgba(23, 185, 120, 0.15)" : "rgba(0, 0, 0, 0.3)" %>; 
                              border: 1px solid <%= isSelezionata ? "#17b978" : "rgba(255,255,255,0.05)" %>;">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                  <strong style="color: #fff; font-size: 14px;">Cliente #<%= c.getCliente() %></strong>
                  <span style="font-size: 11px; color: #888;"><%= c.getDataCreazione() %></span>
                </div>
                <div style="font-size: 11px; color: #aaa; margin-top: 4px;">Ticket ID: #TK-<%= c.getId() %></div>
              </div>
            </a>
          <% 
              }
            } else { 
          %>
            <p style="text-align: center; color: #666; padding: 20px; font-size: 13px;">Nessuna richiesta di supporto attiva.</p>
          <% } %>
        </div>
      </div>

      <div class="admin-glass-panel chat-panel">
        
        <% if (chatSelezionata != null) { %>
          <div style="background: rgba(0,0,0,0.4); padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255,255,255,0.08);">
            <div>
              <h4 style="color: #17b978; margin: 0; font-size: 15px;">Conversazione con Cliente #<%= chatSelezionata.getCliente() %></h4>
              <span style="font-size: 11px; color: #aaa;">Stai visualizzando il ticket #<%= chatSelezionata.getId() %></span>
            </div>
            
            <form action="${pageContext.request.contextPath}/ConcludiChat" method="post" style="margin: 0;">
              <input type="hidden" name="chatId" value="<%= chatSelezionata.getId() %>">
              <button type="submit" class="btn-concludi">Concludi Chat</button>
            </form>
          </div>
          
          <div class="wa-body" id="waBody">
            <% 
              if (cronologiaMessaggi != null && !cronologiaMessaggi.isEmpty()) {
                int idAdminLoggato = ((model.Utente)session.getAttribute("utente")).getId(); 
                for (Messaggio m : cronologiaMessaggi) {
                    boolean isAdminMsg = (m.getMittente() == idAdminLoggato);
            %>
              <div class="msg-bubble <%= isAdminMsg ? "msg-admin" : "msg-client" %>">
                <%= m.getTesto() %>
                <span class="msg-time"><%= m.getDataInvio() %></span>
              </div>
            <% 
                }
              } else { 
            %>
              <p style="text-align: center; color: #555; font-size: 12px; margin-top: 30px;">Nessun messaggio presente. Scrivi qui sotto per rispondere.</p>
            <% } %>
          </div>
          
          <form action="${pageContext.request.contextPath}/InviaMessaggioAssistenza" method="post" style="background: rgba(0,0,0,0.3); padding: 15px; display: flex; gap: 10px; border-top: 1px solid rgba(255,255,255,0.08);">
            <input type="hidden" name="chatId" value="<%= chatSelezionata.getId() %>">
            <input type="hidden" name="redirectUrl" value="view/admin/assistenza?idChat=<%= chatSelezionata.getId() %>">
            
            <input type="text" name="testoMessaggio" placeholder="Scrivi una risposta al cliente..." required autocomplete="off"
                   style="flex: 1; padding: 12px 18px; background: #232d34; border: 1px solid rgba(255,255,255,0.05); border-radius: 24px; color: #fff; font-size: 13px; outline: none;">
            <button type="submit" class="btn-action-edit" style="width: auto; padding: 0 22px; border-radius: 24px; font-weight: bold; cursor: pointer;">Invia</button>
          </form>

        <% } else { %>
          <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100%; color: #556270; text-align: center; padding: 20px;">
            <span style="font-size: 50px; margin-bottom: 10px; opacity: 0.4;">💬</span>
            <h4 style="color: #8c96a0; font-weight: 600; margin: 0;">Nessun Ticket Selezionato</h4>
            <p style="font-size: 12px; color: #646e78; max-width: 280px; margin-top: 6px;">Seleziona una delle richieste dall'elenco a sinistra per consultare i messaggi e scrivere una risposta di supporto.</p>
          </div>
        <% } %>

      </div>
    </main>
  </div>

  <script>
    // Posiziona automaticamente la barra di scorrimento sul fondo all'apertura dei messaggi
    var objDiv = document.getElementById("waBody");
    if (objDiv) {
        objDiv.scrollTop = objDiv.scrollHeight;
    }
  </script>

</body>
</html>