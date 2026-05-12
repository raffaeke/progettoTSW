<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Kick Off — Registrati</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=Barlow:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>

  <header>
    <nav class="nav-left">
      <a href="${pageContext.request.contextPath}/view/Catalogo/maglie">Maglie</a>
      <a href="${pageContext.request.contextPath}/view/Catalogo/completi">Completi</a>
    </nav>
    <a href="${pageContext.request.contextPath}/index.jsp" class="logo-link"><img src="${pageContext.request.contextPath}/images/logo.png" alt="Kick Off Logo"></a>
    <nav class="nav-right">
      <a href="${pageContext.request.contextPath}/view/Catalogo/guantoni">Guantoni</a>
      <a href="${pageContext.request.contextPath}/view/Catalogo/scarpette">Scarpette</a>
      <a href="carrello.jsp" class="icon-link" aria-label="Carrello">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
          <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
        </svg>
      </a>
      <a href="${pageContext.request.contextPath}/view/login" class="icon-link" aria-label="Account">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
          <circle cx="12" cy="7" r="4"/>
        </svg>
      </a>
    </nav>
  </header>

  <div class="auth-wrapper">
    <div class="auth-card">

      <h1 class="auth-title">Registrati</h1>
      <p class="auth-sub">Hai già un account? <a href="${pageContext.request.contextPath}/view/login" class="auth-link">Accedi</a></p>

     
      <% if (request.getAttribute("errore") != null) { %>
        <div class="auth-error"><%= request.getAttribute("errore") %></div>
      <% } %>

      <form class="auth-form" action="${pageContext.request.contextPath}/RegistrazioneServlet" method="post">
        <div class="form-group">
          <label for="username">Username</label>
          <input type="text" id="username" name="username" placeholder="NomeCognome00" required autocomplete="username">
        </div>
        <div class="form-group">
          <label for="email">Email</label>
          <input type="email" id="email" name="email" placeholder="la-tua@email.com" required autocomplete="email">
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input type="password" id="password" name="password" placeholder="••••••••" required autocomplete="new-password">
        </div>
        <div class="form-group">
          <label for="confermaPassword">Conferma password</label>
          <input type="password" id="confermaPassword" name="confermaPassword" placeholder="••••••••" required autocomplete="new-password">
        </div>
        <div class="form-group">
          <label for="indirizzo">Indirizzo</label>
          <input type="text" id="indirizzo" name="indirizzo" placeholder="Via Roma 1" required>
        </div>
        <button type="submit" class="btn-auth">Crea account</button>
      </form>

    </div>
  </div>

</body>
</html>
