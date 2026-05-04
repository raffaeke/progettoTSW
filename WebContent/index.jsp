<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="refresh" content="30">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <title>Kick Off</title>
  <link rel="stylesheet" href="style.css">
</head>

<body>


  <header class="main-header">

    <nav class="nav-left">
      <a href="Catalogo/maglie">Maglie</a>
      <a href="Catalogo/completi">Completi</a>
    </nav>

   
    <a href="index.jsp" class="logo-link">
      <img src="logo.png" alt="Kick Off Logo">
    </a>

   
    <nav class="nav-right">
      <a href="Catalogo/guantoni">Guantoni</a>
      <a href="Catalogo/scarpette">Scarpette</a>

      
      <a href="carrello.jsp" class="icon-link" aria-label="Carrello">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
             stroke-linecap="round" stroke-linejoin="round">
          <circle cx="9" cy="21" r="1"/>
          <circle cx="20" cy="21" r="1"/>
          <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
        </svg>
      </a>

      
      <% if (session.getAttribute("utente") != null) { %>
        <a href="profilo.jsp" class="icon-link icon-link--active" aria-label="Profilo">
      <% } else { %>
        <a href="login.jsp" class="icon-link" aria-label="Accedi">
      <% } %>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
               stroke-linecap="round" stroke-linejoin="round">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
          </svg>
        </a>

    </nav>
  </header>

  S
  <main>

    <section class="field">
      <div class="center-line"></div>
      <div class="center-circle"></div>

      <div class="penalty-box top"></div>
      <div class="goal-box top"></div>

      <div class="penalty-box bottom"></div>
      <div class="goal-box bottom"></div>

      <div class="penalty-spot top"></div>
      <div class="penalty-spot bottom"></div>
    </section>

  </main>

</body>
</html>