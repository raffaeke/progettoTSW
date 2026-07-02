/**
 * Kick Off — catalogo.js
 * Filtri real-time (prezzo, marca, taglia, sconto) + ordinamento + Carrello AJAX
 */
(function () {
  'use strict';

  /* ── Riferimenti DOM ─────────────────────────────────────────── */
  var allCards   = Array.from(document.querySelectorAll('.product-card'));
  var emptyMsg   = document.getElementById('emptyMsg');
  var prodCount  = document.getElementById('prodCount');
  var sortSelect = document.getElementById('sortSelect');
  var resetBtn   = document.getElementById('resetBtn');
  var prezzoMin  = document.getElementById('prezzoMin');
  var prezzoMax  = document.getElementById('prezzoMax');
  var minLabel   = document.getElementById('minLabel');
  var maxLabel   = document.getElementById('maxLabel');

  /* ── Stato filtri ────────────────────────────────────────────── */
  var state = {
    min:    0,
    max:    500,
    marche: [],
    //taglie: [],
    sconto: false,
    sort:   'default'
  };

  /* ── Aggiorna label range prezzo ─────────────────────────────── */
  function updateRangeLabels() {
    if (minLabel) minLabel.textContent = '€' + state.min;
    if (maxLabel) maxLabel.textContent = state.max >= 500 ? '€500+' : '€' + state.max;
  }

  /* ── Applica filtri e ordinamento ───────────────────────────── */
  function applyFilters() {
    var visible = [];

    allCards.forEach(function (card) {
      var prezzo = parseFloat(card.dataset.prezzo) || 0;
      var marca  = (card.dataset.marca  || '').toLowerCase();
     // var taglia = (card.dataset.taglia || '').toLowerCase();
      var sconto = card.dataset.sconto === 'true';

      var okPrezzo = prezzo >= state.min && (state.max >= 500 || prezzo <= state.max);
      var okMarca  = state.marche.length === 0 ||
                     state.marche.some(function(m){ return m === marca; });
     /* var okTaglia = state.taglie.length === 0 ||
                     state.taglie.some(function(t){ return t === taglia; });*/
      var okSconto = !state.sconto || sconto;

      var show = okPrezzo && okMarca /*&& okTaglia */&& okSconto;
      card.hidden = !show;
      if (show) visible.push(card);
    });

    /* Ordinamento */
    visible.sort(function (a, b) {
      switch (state.sort) {
        case 'prezzo-asc':
          return parseFloat(a.dataset.prezzo) - parseFloat(b.dataset.prezzo);
        case 'prezzo-desc':
          return parseFloat(b.dataset.prezzo) - parseFloat(a.dataset.prezzo);
        case 'sconto':
          /* ordina per percentuale sconto decrescente */
          var sa = a.dataset.sconto === 'true' ? 1 : 0;
          var sb = b.dataset.sconto === 'true' ? 1 : 0;
          return sb - sa;
        case 'nome':
          return (a.dataset.nome || '').localeCompare(b.dataset.nome || '', 'it');
        default:
          return 0;
      }
    });

    /* Reinserisce le card nel DOM nell'ordine ordinato */
    var grids = document.querySelectorAll('.products-grid, .products-slider');
    grids.forEach(function (grid) {
      var inGrid = visible.filter(function(c){ return grid.contains(c); });
      inGrid.forEach(function(c){ grid.appendChild(c); });
    });

    /* Contatore + messaggio vuoto */
    var total = allCards.length;
    if (prodCount) prodCount.textContent = visible.length + ' di ' + total + ' prodotti';
    if (emptyMsg)  emptyMsg.hidden = visible.length > 0;
  }

  /* ── Range prezzo ────────────────────────────────────────────── */
  if (prezzoMin) {
    prezzoMin.addEventListener('input', function () {
      state.min = parseInt(this.value, 10);
      if (state.min > state.max - 10) { state.min = state.max - 10; this.value = state.min; }
      updateRangeLabels();
      applyFilters();
    });
  }
  if (prezzoMax) {
    prezzoMax.addEventListener('input', function () {
      state.max = parseInt(this.value, 10);
      if (state.max < state.min + 10) { state.max = state.min + 10; this.value = state.max; }
      updateRangeLabels();
      applyFilters();
    });
  }

  /* ── Checkbox marca / taglia / sconto ────────────────────────── */
  document.querySelectorAll('.filter-check').forEach(function (cb) {
    cb.addEventListener('change', function () {
      var filter = this.dataset.filter;
      var val    = (this.value || '').toLowerCase();

      if (filter === 'sconto') {
        state.sconto = this.checked;
      } else if (filter === 'marca') {
        if (this.checked) { state.marche.push(val); }
        else { state.marche = state.marche.filter(function(m){ return m !== val; }); }
      } /*else if (filter === 'taglia') {
        if (this.checked) { state.taglie.push(val); }
        else { state.taglie = state.taglie.filter(function(t){ return t !== val; }); }
      }*/
      applyFilters();
    });
  });

  /* ── Ordinamento ─────────────────────────────────────────────── */
  if (sortSelect) {
    sortSelect.addEventListener('change', function () {
      state.sort = this.value;
      applyFilters();
    });
  }

  /* ── Reset filtri ────────────────────────────────────────────── */
  if (resetBtn) {
    resetBtn.addEventListener('click', function () {
      state = { min: 0, max: 500, marche: [], taglie: [], sconto: false, sort: state.sort };

      document.querySelectorAll('.filter-check').forEach(function(cb){ cb.checked = false; });
      if (prezzoMin) { prezzoMin.value = 0; }
      if (prezzoMax) { prezzoMax.value = 500; }
      updateRangeLabels();
      applyFilters();
    });
  }

  /* ── Accordion filtri (apri/chiudi) ──────────────────────────── */
  document.querySelectorAll('.filter-toggle').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var targetId = this.dataset.target;
      var body     = document.getElementById(targetId);
      if (!body) return;
      var expanded = this.getAttribute('aria-expanded') === 'true';
      this.setAttribute('aria-expanded', !expanded);
      body.hidden = expanded;
    });
  });

  /* ── Init ────────────────────────────────────────────────────── */
  updateRangeLabels();
  applyFilters();

})();