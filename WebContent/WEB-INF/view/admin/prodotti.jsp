<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.beans.Prodotto" %>
<%@ page import="model.beans.Categoria" %>
<%@ page import="model.dao.ProdottoDAO" %>          <%@ page import="model.daoImpl.ProdottoDAOImpl" %>  <%@ page import="java.util.List" %>
<%
  Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
  if (session.getAttribute("utente") == null || isAdmin == null || !isAdmin) {
      response.sendRedirect(request.getContextPath() + "/view/login");
      return;
  }

  ProdottoDAO jspDao = new ProdottoDAOImpl();
  List<Prodotto> lista = null;
  try {
      lista = jspDao.doRetrieveAll(); // Prende i prodotti direttamente in tempo reale
  } catch(Exception e) {
      request.setAttribute("errore", "Impossibile caricare i prodotti dal database.");
  }

  Prodotto prodDaModificare = (Prodotto) request.getAttribute("prodottoDaModificare");
  boolean isModifica = (prodDaModificare != null);
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Kick Off — Gestione Prodotti</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=Barlow:wght@400;600&display=swap" rel="stylesheet">
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
        <a href="${pageContext.request.contextPath}/view/admin/dashboard" class="admin-badge" style="text-decoration: none;">← TORNA ALLA DASHBOARD</a>
      </div>
      <a href="${pageContext.request.contextPath}/index.jsp" class="logo-link">
        <img src="${pageContext.request.contextPath}/images/logo.png" alt="Kick Off Logo">
      </a>
      <div class="nav-right">
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-admin-logout">Esci</a>
      </div>
    </header>

    <main class="admin-container" style="position: relative; z-index: 2; padding-top: 130px; padding-bottom: 40px; max-width: 1400px;">
      
      <% if (request.getAttribute("errore") != null) { %>
        <div class="auth-error" style="margin-bottom: 20px;"><%= request.getAttribute("errore") %></div>
      <% } %>

      <div class="admin-split-layout">
        
        <div class="admin-glass-panel user-form-panel">
          <h2><%= isModifica ? "Modifica Prodotto" : "Nuovo Prodotto" %></h2>
          
          <form class="auth-form" action="${pageContext.request.contextPath}/GestioneProdotti" method="post">
            <input type="hidden" name="id" value="<%= isModifica ? prodDaModificare.getId() : "0" %>">

            <div class="form-group">
              <label for="nome">Nome Articolo</label>
              <input type="text" id="nome" name="nome" required placeholder="Es. Maglia Juventus 2026" 
                     value="<%= isModifica ? prodDaModificare.getNome() : "" %>">
            </div>

            <div class="form-group">
              <label for="desc">Descrizione</label>
              <input type="text" id="desc" name="desc" required placeholder="Es. Maglia ufficiale da gara..." 
                     value="<%= isModifica ? prodDaModificare.getDesc() : "" %>">
            </div>

            <div class="form-row">
              <div class="form-group">
                <label for="prezzo">Prezzo (€)</label>
                <input type="number" id="prezzo" name="prezzo" step="0.01" required placeholder="89.99" 
                       value="<%= isModifica ? prodDaModificare.getPrezzo() : "" %>">
              </div>

              <div class="form-group">
                <label for="sconto">Sconto (%)</label>
                <input type="number" id="sconto" name="sconto" min="0" max="99" placeholder="0" 
                       value="<%= isModifica ? prodDaModificare.getSconto() : "0" %>">
              </div>
            </div>

            <div class="form-group">
              <label for="categoria">Categoria</label>
              <select id="categoria" name="categoria" required class="admin-select">
                <% for(Categoria c : Categoria.values()) { %>
                  <option value="<%= c.name() %>" <%= (isModifica && prodDaModificare.getCat() == c) ? "selected" : "" %>>
                    <%= c.name().toUpperCase() %>
                  </option>
                <% } %>
              </select>
            </div>

            <div class="form-group checkbox-group">
              <label class="container-checkbox">
                <input type="checkbox" name="inEvidenza" id="inEvidenza" <%= (isModifica && prodDaModificare.isInEvidenza()) ? "checked" : "" %>>
                <span class="checkmark"></span>
                Metti l'articolo In Evidenza nella Home
              </label>
            </div>

            <button type="submit" class="btn-auth">
              <%= isModifica ? "Aggiorna Articolo" : "Inserisci nel Catalogo" %>
            </button>
            
            <% if(isModifica) { %>
              <a href="${pageContext.request.contextPath}/GestioneProdotti" class="btn-admin-logout" style="text-align:center; background:#444; margin-top:5px;">Annulla Modifica</a>
            <% } %>
          </form>
        </div>

        <div class="admin-glass-panel table-panel">
          <h2>Inventario Negozio</h2>
          
          <div class="table-wrapper">
            <table class="admin-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Prodotto</th>
                  <th>Categoria</th>
                  <th>Prezzo</th>
                  <th>Stato</th>
                  <th>Azioni</th>
                </tr>
              </thead>
              <tbody>
                <% 
                  if (lista != null && !lista.isEmpty()) {
                    for(Prodotto prod : lista) {
                %>
                  <tr>
                    <td><span class="td-id">#<%= prod.getId() %></span></td>
                    <td>
                      <div class="td-product-title"><%= prod.getNome() %></div>
                      <div class="td-product-desc"><%= prod.getDesc() %></div>
                    </td>
                    <td><span class="cat-tag"><%= prod.getCat().name() %></span></td>
                    <td>
                      <span class="td-price"><%= String.format("%.2f", prod.getPrezzo()) %>€</span>
                      <% if(prod.getSconto() > 0) { %>
                        <span class="discount-badge">-<%= prod.getSconto() %>%</span>
                      <% } %>
                    </td>
                    <td>
                      <% if(prod.isInEvidenza()) { %>
                        <span class="status-badge live">HOME</span>
                      <% } else { %>
                        <span class="status-badge standard">STANDARD</span>
                      <% } %>
                    </td>
                    <td>
                      <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/GestioneProdotti?action=modifica&id=<%= prod.getId() %>" class="btn-action-edit">Matita</a>
                        <a href="${pageContext.request.contextPath}/GestioneProdotti?action=elimina&id=<%= prod.getId() %>" class="btn-action-delete" onclick="return confirm('Sicuro di voler eliminare questo prodotto?');">Cestino</a>
                      </div>
                    </td>
                  </tr>
                <% 
                    }
                  } else { 
                %>
                  <tr>
                    <td colspan="6" style="text-align: center; color: #888; padding: 40px;">Nessun prodotto presente nel catalogo.</td>
                  </tr>
                <% } %>
              </tbody>
            </table>
          </div>
        </div>

      </div>
    </main>

  </div>

</body>
</html>