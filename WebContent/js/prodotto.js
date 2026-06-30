/**
 * Kick Off — prodotto.js
 * Gestisce: galleria immagini, selezione taglia, stelle recensione
 */
(function () {
  'use strict';

  /* ──────────────────────────────────────────────
     GALLERIA IMMAGINI
     ────────────────────────────────────────────── */
  var mainImg   = document.getElementById('mainImg');
  var thumbBtns = document.querySelectorAll('.thumb-btn');

  thumbBtns.forEach(function (btn) {
    btn.addEventListener('click', function () {
      if (!mainImg) return;

      /* Aggiorna immagine principale */
      mainImg.src = this.dataset.src;
      mainImg.style.opacity = '0';
      mainImg.onload = function () {
        mainImg.style.transition = 'opacity .25s';
        mainImg.style.opacity = '1';
      };

      /* Aggiorna stato active sui thumbnail */
      thumbBtns.forEach(function (b) { b.classList.remove('active'); });
      this.classList.add('active');
    });
  });

  /* ──────────────────────────────────────────────
     SELEZIONE TAGLIA
     ────────────────────────────────────────────── */
  var tagliaBtns  = document.querySelectorAll('.taglia-btn:not(:disabled)');
  var tagliaSel   = document.getElementById('tagliaSel');
  var tagliaAvviso= document.getElementById('tagliaAvviso');
  var specIdInput = null; /* creato dinamicamente al click */

  tagliaBtns.forEach(function (btn) {
    btn.addEventListener('click', function () {
      /* Deseleziona tutti */
      tagliaBtns.forEach(function (b) { b.classList.remove('selected'); });

      /* Seleziona questo */
      this.classList.add('selected');

      /* Aggiorna label */
      if (tagliaSel) tagliaSel.textContent = this.dataset.taglia;

      /* Nascondi avviso */
      if (tagliaAvviso) tagliaAvviso.hidden = true;

      /* Salva spec_id come data sull'ancora carrello */
      var btnCarrello = document.getElementById('btnCarrello');
      if (btnCarrello) {
        btnCarrello.dataset.specId = this.dataset.specId;
      }
    });
  });

  /* ──────────────────────────────────────────────
     AGGIUNGI AL CARRELLO
     ────────────────────────────────────────────── */
  window.aggiungiCarrello = function (e) {
    e.preventDefault();

    var selected = document.querySelector('.taglia-btn.selected');

    if (!selected) {
      /* Nessuna taglia selezionata: mostra avviso e scuoti la griglia */
      if (tagliaAvviso) tagliaAvviso.hidden = false;
      var grid = document.getElementById('tagliaGrid');
      if (grid) {
        grid.style.animation = 'shake .35s ease';
        grid.addEventListener('animationend', function () {
          grid.style.animation = '';
        }, { once: true });
      }
      return false;
    }

    var ctx    = document.body.dataset.ctx || '';
    var specId = selected.dataset.specId;
    window.location.href = ctx + '/CarrelloServlet?action=aggiungi&specId=' + specId;
    return false;
  };

  /* ──────────────────────────────────────────────
     STELLE RECENSIONE
     ────────────────────────────────────────────── */
  var starBtns  = document.querySelectorAll('.star-btn');
  var votoInput = document.getElementById('votoInput');

  starBtns.forEach(function (btn, idx) {
    /* Hover: illumina fino alla stella corrente */
    btn.addEventListener('mouseenter', function () {
      starBtns.forEach(function (b, i) {
        b.querySelector('svg').style.fill   = i <= idx ? '#2f8f3a' : 'none';
        b.querySelector('svg').style.stroke = i <= idx ? '#2f8f3a' : '#444';
      });
    });

    /* Mouse leave: ripristina in base al voto salvato */
    btn.addEventListener('mouseleave', function () {
      var saved = votoInput ? parseInt(votoInput.value, 10) : 0;
      starBtns.forEach(function (b, i) {
        b.querySelector('svg').style.fill   = i < saved ? '#2f8f3a' : 'none';
        b.querySelector('svg').style.stroke = i < saved ? '#2f8f3a' : '#444';
      });
    });

    /* Click: salva voto */
    btn.addEventListener('click', function () {
      var val = parseInt(btn.dataset.val, 10);
      if (votoInput) votoInput.value = val;
      starBtns.forEach(function (b) { b.classList.remove('active'); });
      /* Marca attive fino alla stella cliccata */
      for (var i = 0; i < val; i++) { starBtns[i].classList.add('active'); }
    });
  });

  /* ──────────────────────────────────────────────
     ANIMAZIONE SHAKE (CSS keyframe via JS)
     ────────────────────────────────────────────── */
  var style = document.createElement('style');
  style.textContent = '@keyframes shake{0%,100%{transform:translateX(0)}20%{transform:translateX(-6px)}40%{transform:translateX(6px)}60%{transform:translateX(-4px)}80%{transform:translateX(4px)}}';
  document.head.appendChild(style);

})();
