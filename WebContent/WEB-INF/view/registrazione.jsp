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
  
  <style>
    .form-row {
      display: flex;
      gap: 15px;
      width: 100%;
    }
    .form-row .form-group {
      flex: 1; /* Distribuisce lo spazio equamente */
    }
    .form-row .form-group.short {
      flex: 0 0 80px; /* La provincia rimane stretta */
    }
  </style>
</head>
<body>

  <header>
     <nav class="nav-left">
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=MAGLIE">Maglie</a>
      <a href="<%= request.getContextPath() %>/Catalogo?tipo=COMPLETO">Completi</a>
    </nav>

    <a href="index.jsp" class="logo-link">
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
  <div class="auth-wrapper">
  <div class="auth-card auth-card--wide"> 

    <h1 class="auth-title">Registrati</h1>
    <p class="auth-sub">Hai già un account? <a href="${pageContext.request.contextPath}/view/login" class="auth-link">Accedi</a></p>

    <% if (request.getAttribute("errore") != null) { %>
      <div class="auth-error"><%= request.getAttribute("errore") %></div>
    <% } %>

    <form class="auth-form" action="${pageContext.request.contextPath}/RegistrazioneServlet" method="post">
      
      <div class="form-row">
        <div class="form-group">
          <label for="nome">Nome</label>
          <input type="text" id="nome" name="nome" placeholder="Mario" required autocomplete="given-name">
        </div>
        <div class="form-group">
          <label for="cognome">Cognome</label>
          <input type="text" id="cognome" name="cognome" placeholder="Rossi" required autocomplete="family-name">
        </div>
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

      <div class="form-row">
      
      <div class="form-group row-paese">
          <label for="paese">Paese</label>
          <input type="text" id="paese" name="paese" placeholder="Italia" required>
        </div>
        
        <div class="form-group row-indirizzo">
          <label for="indirizzo">Indirizzo</label>
          <input type="text" id="indirizzo" name="indirizzo" placeholder="Via Roma 1"  required>
        </div>

        <div class="form-group row-provincia">
          <label for="provincia">Prov.</label>
          <input type="text" id="provincia" name="provincia" placeholder="NA" required size="2" maxlength="2">
        </div>
      </div>

      <button type="submit" class="btn-auth">Crea account</button>
    </form>

  </div>
</div>
</div>

</body>
</html>