<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  //se non loggato rimanda al login
  if (session.getAttribute("utente") == null) {
      response.sendRedirect("login.jsp");
      return;
  }
  // Recupera i dati dell'utente dalla sessione
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Kick Off — Profilo</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=Barlow:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="style.css">
</head>
<body>

  <header>
    <nav class="nav-left">
      <a href="Catalogo/maglie">Maglie</a>
      <a href="Catalogo/completi">Completi</a>
    </nav>
    <a href="index.jsp" class="logo-link"><img src="logo.png" alt="Kick Off Logo"></a>
    <nav class="nav-right">
      <a href="Catalogo/guantoni">Guantoni</a>
      <a href="Catalogo/scarpette">Scarpette</a>
      <a href="carrello.jsp" class="icon-link" aria-label="Carrello">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
          <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
        </svg>
        
      <a href="profilo.jsp" class="icon-link icon-link--active" aria-label="Profilo">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
          <circle cx="12" cy="7" r="4"/>
        </svg>
      </a>
    </nav>
  </header>

  <div class="auth-wrapper">
    <div class="auth-card profilo-card">

      <div class="profilo-avatar">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
          <circle cx="12" cy="7" r="4"/>
        </svg>
      </div>

      <h1 class="auth-title">Il tuo profilo</h1>

     
      <div class="profilo-info">
        <div class="profilo-row">
          <span class="profilo-label">Nome</span>
          <%@ page import="model.Utente" %>
          <% Utente user = (Utente) session.getAttribute("utente"); %>
          <span class="profilo-value"><%= user.getUsername() %></span>
        </div>
      </div>

      <div class="profilo-actions">
        <a href="LogoutServlet" class="btn-logout">Esci dall'account</a>
      </div>

    </div>
  </div>

</body>
</html>
