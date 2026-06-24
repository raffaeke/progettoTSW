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
  var searchInput  = document.getElementById('searchInput');
  var searchSubmit = document.getElementById('searchSubmit');
  var searchTags   = document.querySelectorAll('.search-tag');

  if (!searchInput) return;

  function doSearch() {
    var query = searchInput.value.trim();
    if (!query) { searchInput.focus(); return; }
    var ctx = document.body.dataset.ctx || '';
    window.location.href = ctx + '/view/Catalogo/cerca?q=' + encodeURIComponent(query);
  }

  searchSubmit.addEventListener('click', function (e) { e.preventDefault(); doSearch(); });
  searchInput.addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); doSearch(); } });

  searchTags.forEach(function (tag) {
    tag.addEventListener('click', function (e) {
      e.preventDefault();
      searchInput.value = tag.dataset.value;
      doSearch();
    });
  });

})();