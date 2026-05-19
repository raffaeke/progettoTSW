<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.beans.Utente" %>
<%
  // Se non loggato rimanda al login tramite la NavigationServlet
  if (session.getAttribute("utente") == null) {
      response.sendRedirect(request.getContextPath() + "/view/login");
      return;
  }
  // Recupera i dati dell'utente dalla sessione
  Utente user = (Utente) session.getAttribute("utente");
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Kick Off — Profilo</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=Barlow:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
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
        <a href="${pageContext.request.contextPath}/view/Catalogo/maglie">Maglie</a>
        <a href="${pageContext.request.contextPath}/view/Catalogo/completi">Completi</a>
      </nav>
      <a href="${pageContext.request.contextPath}/index.jsp" class="logo-link"><img src="${pageContext.request.contextPath}/images/logo.png" alt="Kick Off Logo"></a>
      <nav class="nav-right">
        <a href="${pageContext.request.contextPath}/view/Catalogo/guantoni">Guantoni</a>
        <a href="${pageContext.request.contextPath}/view/Catalogo/scarpette">Scarpette</a>
        <a href="${pageContext.request.contextPath}/view/carrello" class="icon-link" aria-label="Carrello">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
            <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
          </svg>
        </a> <a href="${pageContext.request.contextPath}/view/profilo" class="icon-link icon-link--active" aria-label="Profilo">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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

        <div class="profilo-info">
          <div class="profilo-row">
            <span class="profilo-label">Nome e Cognome</span>
            <span class="profilo-value"><%= user.getNome() + " " + user.getCognome() %></span>
          </div>
          <div class="profilo-row">
            <span class="profilo-label">Email</span>
            <span class="profilo-value"><%= user.getEmail() %></span>
          </div>
          <div class="profilo-row">
            <span class="profilo-label">Indirizzo</span>
            <span class="profilo-value"><%= user.getIndirizzo() + ", " + user.getProvincia() + " (" + user.getPaese() + ")" %></span>
          </div>
        </div>

        <div class="profilo-actions" style="margin-top: 24px;">
          <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-logout">Esci dall'account</a>
        </div>

      </div>
    </div>

  </div>

</body>
</html>