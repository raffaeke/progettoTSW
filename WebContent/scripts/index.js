/**
 * Kick Off — carousel.js
 * Gestisce il carosello hero e la barra di ricerca
 */
(function () {
  'use strict';

  /* -----------------------------------------------
     CAROSELLO
     ----------------------------------------------- */
  var track    = document.getElementById('slidesTrack');
  var dots     = document.querySelectorAll('.carousel-dot');
  var btnPrev  = document.getElementById('carouselPrev');
  var btnNext  = document.getElementById('carouselNext');
  var carousel = document.getElementById('carousel');

  if (!track || !btnPrev || !btnNext) return;

  var TOTAL      = document.querySelectorAll('.slide').length;
  var AUTO_DELAY = 4500;
  var current    = 0;
  var autoTimer  = null;
  var touchStartX = 0;

  function goTo(n) {
    current = ((n % TOTAL) + TOTAL) % TOTAL;
    track.style.transform = 'translateX(-' + (current * 100) + '%)';
    dots.forEach(function (dot, i) {
      dot.classList.toggle('active', i === current);
      dot.setAttribute('aria-selected', i === current ? 'true' : 'false');
    });
  }

  function startAuto() {
    stopAuto();
    autoTimer = setInterval(function () { goTo(current + 1); }, AUTO_DELAY);
  }

  function stopAuto() {
    if (autoTimer) { clearInterval(autoTimer); autoTimer = null; }
  }

  /* Frecce — type="button" previene submit accidentali in form JSP */
  btnPrev.addEventListener('click', function (e) {
    e.preventDefault();
    goTo(current - 1);
    startAuto();
  });
  btnNext.addEventListener('click', function (e) {
    e.preventDefault();
    goTo(current + 1);
    startAuto();
  });

  /* Pallini */
  dots.forEach(function (dot) {
    dot.addEventListener('click', function (e) {
      e.preventDefault();
      goTo(parseInt(dot.dataset.index, 10));
      startAuto();
    });
  });

  /* Pausa hover */
  carousel.addEventListener('mouseenter', stopAuto);
  carousel.addEventListener('mouseleave', startAuto);

  /* Pausa se tab nascosta */
  document.addEventListener('visibilitychange', function () {
    if (document.hidden) { stopAuto(); } else { startAuto(); }
  });

  /* Swipe touch */
  carousel.addEventListener('touchstart', function (e) {
    touchStartX = e.changedTouches[0].clientX;
  }, { passive: true });
  carousel.addEventListener('touchend', function (e) {
    var dx = touchStartX - e.changedTouches[0].clientX;
    if (Math.abs(dx) > 50) { goTo(current + (dx > 0 ? 1 : -1)); startAuto(); }
  }, { passive: true });

  /* Tastiera */
  document.addEventListener('keydown', function (e) {
    if (e.key === 'ArrowLeft')  { goTo(current - 1); startAuto(); }
    if (e.key === 'ArrowRight') { goTo(current + 1); startAuto(); }
  });

  startAuto();


  /* -----------------------------------------------
     BARRA DI RICERCA
     ----------------------------------------------- */
  var searchInput   = document.getElementById('searchInput');
  var searchSubmit  = document.getElementById('searchSubmit');
  var searchTags    = document.querySelectorAll('.search-tag');
  var searchResults = document.getElementById('searchResults');
  var ctx           = document.body.dataset.ctx || '';
  var debounceTimer = null;
  var ultimaRichiesta = 0;

  if (!searchInput) return;

  function doSearch() {
    var query = searchInput.value.trim();
    if (!query) { searchInput.focus(); return; }
    nascondiRisultati();
    window.location.href = ctx + '/Catalogo?q=' + encodeURIComponent(query);
  }

  function nascondiRisultati() {
    if (searchResults) {
      searchResults.hidden = true;
      searchResults.innerHTML = '';
    }
  }

  /* Disegna il dropdown con i prodotti trovati (max 8, gia' limitati dal server) */
  function mostraRisultati(prodotti) {
    if (!searchResults) return;

    if (!prodotti.length) {
      searchResults.innerHTML = '<p class="search-results-empty">Nessun prodotto trovato.</p>';
      searchResults.hidden = false;
      return;
    }

    var html = '';
    prodotti.forEach(function (p) {
      var imgSrc = p.immagine ? (ctx + '/images/prodotti/' + p.immagine) : (ctx + '/images/logo.png');
      html += '<a class="search-result-item" href="' + ctx + '/prodotto?id=' + p.id + '">'
            +   '<img src="' + imgSrc + '" alt="" onerror="this.src=\'' + ctx + '/images/logo.png\'">'
            +   '<span class="sr-info">'
            +     '<span class="sr-marca">' + p.marca + '</span>'
            +     '<span class="sr-nome">' + p.nome + '</span>'
            +   '</span>'
            +   '<span class="sr-prezzo">€' + p.prezzo.toFixed(2) + '</span>'
            + '</a>';
    });
    searchResults.innerHTML = html;
    searchResults.hidden = false;
  }

  /* Interroga /CercaProdotti in AJAX, con debounce per non spammare il server ad ogni tasto */
  searchInput.addEventListener('input', function () {
    var query = searchInput.value.trim();
    clearTimeout(debounceTimer);

    if (!query) { nascondiRisultati(); return; }

    debounceTimer = setTimeout(function () {
      var richiestaCorrente = ++ultimaRichiesta;
      fetch(ctx + '/CercaProdotti?q=' + encodeURIComponent(query))
        .then(function (res) { return res.json(); })
        .then(function (prodotti) {
          /* Scarta risposte arrivate in ritardo rispetto a una ricerca piu' recente */
          if (richiestaCorrente === ultimaRichiesta) mostraRisultati(prodotti);
        })
        .catch(function () { nascondiRisultati(); });
    }, 300);
  });

  /* Chiude il dropdown cliccando fuori dalla barra di ricerca */
  document.addEventListener('click', function (e) {
    if (searchResults && !searchResults.hidden
        && !searchInput.contains(e.target) && !searchResults.contains(e.target)) {
      nascondiRisultati();
    }
  });

  searchInput.addEventListener('keydown', function (e) {
    if (e.key === 'Enter') { e.preventDefault(); doSearch(); }
    if (e.key === 'Escape') { nascondiRisultati(); }
  });

  searchSubmit.addEventListener('click', function (e) { e.preventDefault(); doSearch(); });

  searchTags.forEach(function (tag) {
    tag.addEventListener('click', function (e) {
      e.preventDefault();
      searchInput.value = tag.dataset.value;
      doSearch();
    });
  });

})();