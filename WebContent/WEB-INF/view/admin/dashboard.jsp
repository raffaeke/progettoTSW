<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.beans.Utente" %>
<%
  Utente user = (Utente) session.getAttribute("utente");
  Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");

  if (user == null || isAdmin == null || !isAdmin) {
      response.sendRedirect(request.getContextPath() + "/view/login");
      return;
  }
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Kick Off — Pannello Admin</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght=700;900&family=Barlow:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css"> 
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
        <span class="admin-badge">PANNELLO AMMINISTRATORE</span>
      </div>
      <a href="${pageContext.request.contextPath}/index.jsp" class="logo-link">
        <img src="${pageContext.request.contextPath}/images/logo.png" alt="Kick Off Logo">
      </a>
      <div class="nav-right">
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-admin-logout">Esci</a>
         </div>
    </header>

   <main class="admin-container" style="position: relative; z-index: 2; padding-top: 140px; padding-bottom: 40px; width: 100%;">
      <div class="admin-glass-panel">
        <h1>Gestione Negozio</h1>
        
        <div class="admin-grid">
          <div class="admin-card">
            <h3>Catalogo Prodotti</h3>
            <p>Aggiungi, modifica o elimina gli articoli dal negozio di Kick Off.</p>
            <a href="${pageContext.request.contextPath}/view/admin/prodotti" class="btn-admin">Gestisci</a>
          </div>

          <div class="admin-card">
            <h3>Ordini Ricevuti</h3>
            <p>Visualizza lo storico degli acquisti effettuati dai clienti sul portale.</p>
            <a href="${pageContext.request.contextPath}/view/admin/ordini" class="btn-admin">Vedi Ordini</a>
          </div>
          
          <div class="admin-card">
            <h3>Assistenza Clienti</h3>
            <p>Rispondi alle richieste effettuate dai clienti sul portale.</p>
            ><a href="${pageContext.request.contextPath}/view/admin/assistenza" class="btn-admin">Vedi Richieste</a>
          </div>
        </div>
      </div>
    </main>

  </div>

</body>
</html>