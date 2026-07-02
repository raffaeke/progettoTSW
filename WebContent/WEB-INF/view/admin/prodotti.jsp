<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Prodotto" %>
<%@ page import="model.Categoria" %>
<%@ page import="dao.ProdottoDAO" %>          
<%@ page import="daoImpl.ProdottoDAOImpl" %>  
<%@ page import="java.util.List" %>
<%
  Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
  if (session.getAttribute("utente") == null || isAdmin == null || !isAdmin) {
      response.sendRedirect(request.getContextPath() + "/view/login");
      return;
  }

  ProdottoDAO jspDao = new ProdottoDAOImpl();
  List<Prodotto> listaCompleta = null;
  try {
      listaCompleta = jspDao.doRetrieveAll(); 
  } catch(Exception e) {
      request.setAttribute("errore", "Impossibile caricare i prodotti dal database: " + e.getMessage());
  }

  // ════════════ LOGICA DI IMPAGINAZIONE ════════════
  int prodottiPerPagina = 10; // Quanti prodotti vuoi vedere per pagina
  int paginaCorrente = 1;
  
  String paramPagina = request.getParameter("page");
  if (paramPagina != null && !paramPagina.isEmpty()) {
      try {
          paginaCorrente = Integer.parseInt(paramPagina);
      } catch(NumberFormatException e) {
          paginaCorrente = 1;
      }
  }

  int totaleProdotti = (listaCompleta != null) ? listaCompleta.size() : 0;
  // Calcolo matematico del numero totale di pagine
  int totalePagine = (int) Math.ceil((double) totaleProdotti / prodottiPerPagina);
  if (totalePagine == 0) totalePagine = 1;

  // Protezione contro numeri di pagina fuori target
  if (paginaCorrente < 1) paginaCorrente = 1;
  if (paginaCorrente > totalePagine) paginaCorrente = totalePagine;

  // Estraiamo la sottolista da mostrare nella tabella
  int indiceInizio = (paginaCorrente - 1) * prodottiPerPagina;
  int indiceFine = Math.min(indiceInizio + prodottiPerPagina, totaleProdotti);
  
  List<Prodotto> listaPaginata = null;
  if (listaCompleta != null && totaleProdotti > 0) {
      listaPaginata = listaCompleta.subList(indiceInizio, indiceFine);
  }
  // ═════════════════════════════════════════════════

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
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/base.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/auth.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/admin.css">
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
        <a href="<%= request.getContextPath() %>/view/admin/dashboard" class="admin-badge" style="text-decoration: none;">← TORNA ALLA DASHBOARD</a>
      </div>
      <a href="<%= request.getContextPath() %>/" class="logo-link">
        <img src="<%= request.getContextPath() %>/images/logo.png" alt="Kick Off Logo">
      </a>
      <div class="nav-right">
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn-admin-logout">Esci</a>
      </div>
    </header>

    <main class="admin-container" style="position: relative; z-index: 2; padding-top: 130px; padding-bottom: 40px; max-width: 1400px;">
      
      <% if (request.getAttribute("errore") != null) { %>
        <div class="auth-error" style="margin-bottom: 20px;"><%= request.getAttribute("errore") %></div>
      <% } %>

      <div class="admin-split-layout">
        
        <div class="admin-glass-panel user-form-panel">
          <h2><%= isModifica ? "Modifica Prodotto" : "Nuovo Prodotto" %></h2>
          
          <form class="auth-form" action="<%= request.getContextPath() %>/GestioneProdotti" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%= isModifica ? prodDaModificare.getId() : "0" %>">

            <div class="form-row">
              <div class="form-group">
                <label for="nome">Nome Articolo</label>
                <input type="text" id="nome" name="nome" required placeholder="Es. Predator Accuracy" 
                       value="<%= isModifica ? prodDaModificare.getNome() : "" %>">
              </div>

              <div class="form-group">
                <label for="marca">Marca</label>
                <input type="text" id="marca" name="marca" required placeholder="Es. Adidas" 
                       value="<%= isModifica ? prodDaModificare.getMarca() : "" %>">
              </div>
            </div>

            <div class="form-group">
              <label for="desc">Descrizione</label>
              <input type="text" id="desc" name="desc" required placeholder="Es. Scarpe con tomaia HybridTouch..." 
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

            <div class="form-row">
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

              <div class="form-group">
                <label for="foto">Foto Prodotto</label>
                <input type="file" id="foto" name="foto" accept="image/*" <%= isModifica ? "" : "required" %> style="padding: 7px; color: #fff;">
              </div>
            </div>

            <div style="border-top: 1px solid rgba(255,255,255,0.1); margin-top: 15px; padding-top: 15px;">
              <h3 style="font-family: 'Barlow Condensed', sans-serif; color: #17b978; text-transform: uppercase; margin-bottom: 10px; font-size: 18px;">Specifiche Magazzino</h3>
              
              <div class="form-row">
                <div class="form-group">
                  <label for="taglia">Taglia</label>
                  <input type="text" id="taglia" name="taglia" required placeholder="Es. M, 42, 9" 
                         value="<%= (isModifica && request.getAttribute("tagliaDaModificare") != null) ? request.getAttribute("tagliaDaModificare") : "" %>">
                </div>

                <div class="form-group">
                  <label for="quantita">Quantità Stock</label>
                  <input type="number" id="quantita" name="quantita" min="0" required placeholder="10" 
                         value="<%= (isModifica && request.getAttribute("quantitaDaModificare") != null) ? request.getAttribute("quantitaDaModificare") : "1" %>">
                </div>
              </div>
            </div>

            <div class="form-group checkbox-group" style="margin-top: 10px;">
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
              <a href="<%= request.getContextPath() %>/GestioneProdotti" class="btn-admin-logout" style="text-align:center; background:#444; margin-top:5px; display: block; text-decoration: none; line-height: 35px;">Annulla Modifica</a>
            <% } %>
          </form>
        </div>

        <div class="admin-glass-panel table-panel">
          <h2>Inventario Negozio (<%= totaleProdotti %> totali)</h2>
          
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
                  // Usiamo la listaPaginata (massimo 10 elementi) anziché la lista completa
                  if (listaPaginata != null && !listaPaginata.isEmpty()) {
                    for(Prodotto prod : listaPaginata) {
                %>
                  <tr>
                    <td><span class="td-id">#<%= prod.getId() %></span></td>
                    <td>
                      <div class="td-product-title">
                        <strong style="color: #17b978;"><%= prod.getMarca() %></strong> — <%= prod.getNome() %>
                      </div>
                      <div class="td-product-desc"><%= prod.getDesc() %></div>
                    </td>
                    <td><span class="cat-tag"><%= prod.getCat().name() %></span></td>
                    <td>
                      <span class="td-price"><%= String.format("%.2f", prod.getPrezzoScontato()) %>€</span>
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
                        <a href="<%= request.getContextPath() %>/GestioneProdotti?action=modifica&id=<%= prod.getId() %>" class="btn-action-edit" style="text-decoration: none; text-align: center;">Matita</a>
                        <a href="<%= request.getContextPath() %>/GestioneProdotti?action=elimina&id=<%= prod.getId() %>" class="btn-action-delete" style="text-decoration: none; text-align: center;" onclick="return confirm('Sicuro di voler eliminare questo prodotto?');">Cestino</a>
                      </div>
                    </td>
                  </tr>
                <% 
                    }
                  } else { 
                %>
                  <tr>
                    <td colspan="6" style="text-align: center; color: #888; padding: 40px;">Nessun prodotto presente in questa pagina.</td>
                  </tr>
                <% } %>
              </tbody>
            </table>
          </div>

          <%-- ════════════ CONTROLLI DI IMPAGINAZIONE INTERFACCIA ════════════ --%>
          <div class="pagination-container">
            <div class="pagination-info">
              Mostrati <%= indiceInizio + 1 %>-<%= indiceFine %> di <%= totaleProdotti %> articoli (Pagina <%= paginaCorrente %> di <%= totalePagine %>)
            </div>
            <div class="pagination-buttons">
              <%-- Tasto Precedente --%>
              <% if (paginaCorrente > 1) { %>
                <a href="?page=<%= paginaCorrente - 1 %>" class="btn-page">« Prec</a>
              <% } else { %>
                <a class="btn-page disabled">« Prec</a>
              <% } %>

              <%-- Elenco numerico delle pagine --%>
              <% for (int i = 1; i <= totalePagine; i++) { %>
                <a href="?page=<%= i %>" class="btn-page <%= (i == paginaCorrente) ? "active" : "" %>"><%= i %></a>
              <% } %>

              <%-- Tasto Successivo --%>
              <% if (paginaCorrente < totalePagine) { %>
                <a href="?page=<%= paginaCorrente + 1 %>" class="btn-page">Succ »</a>
              <% } else { %>
                <a class="btn-page disabled">Succ »</a>
              <% } %>
            </div>
          </div>
          <%-- ═══════════════════════════════════════════════════════════════ --%>

        </div>

      </div>
    </main>

  </div>

</body>
</html>