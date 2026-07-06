<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%
  //Serve in caso di checkout/recensione/assistenza, dove è necessario l accesso, 
  //cosi se uno ha richiesto il login da quelle pagine ritornerà li subito dopo
  
  String redirectParam = request.getParameter("redirect");
  if (redirectParam == null) redirectParam = "";

  Object erroreAttr = request.getAttribute("errore");
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Kick Off — Accedi</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=Barlow:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/auth.css">
</head>

<body>

  
  <header class="main-header">
    <nav class="nav-left">
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=MAGLIE">Maglie</a>
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=COMPLETO">Completi</a>
    </nav>

    <a href="<%= request.getContextPath() %>/" class="logo-link">
      <img src="<%= request.getContextPath() %>/images/logo.png" alt="Kick Off Logo">
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

  
  <main class="auth-page">

    <div class="field field--background">
      <div class="center-line"></div>
      <div class="center-circle"></div>

      <div class="penalty-box top"></div>
      <div class="goal-box top"></div>

      <div class="penalty-box bottom"></div>
      <div class="goal-box bottom"></div>

      <div class="penalty-spot top"></div>
      <div class="penalty-spot bottom"></div>
    </div>

    <!-- FORM -->
    <div class="auth-wrapper">
      <div class="auth-card">

        <h1 class="auth-title">Accedi</h1>
        <p class="auth-sub">
          Non hai un account?
          <a href="${pageContext.request.contextPath}/view/registrazione" class="auth-link">Registrati</a>
        </p>

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

        <form id="loginForm" class="auth-form" action="${pageContext.request.contextPath}/LoginServlet" method="post" novalidate>
          <input type="hidden" name="redirect" value="<%= redirectParam %>">
          <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email"
                   placeholder="la-tua@email.com"
                   required autocomplete="email">
          </div>

          <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   placeholder="••••••••"
                   required autocomplete="current-password">
          </div>

          <button type="submit" class="btn-auth">Accedi</button>
        </form>

      </div>
    </div>

  </main>

  <script src="<%= request.getContextPath() %>/scripts/auth.js"></script>
</body>
</html>