/**
 * Kick Off — checkout.js
 * Gestisce: validazione lato client del form di checkout (indirizzo + carta finta)
 */
(function () {
  'use strict';

  var form = document.getElementById('checkoutForm');
  if (!form) return;

  /* ──────────────────────────────────────────────
     HELPER ERRORI INLINE
     ────────────────────────────────────────────── */
  function showError(input, msg) {
    input.classList.add('input-error');
    var next = input.nextElementSibling;
    if (!next || !next.classList.contains('field-error')) {
      next = document.createElement('span');
      next.className = 'field-error';
      input.insertAdjacentElement('afterend', next);
    }
    next.textContent = msg;
  }

  function clearError(input) {
    input.classList.remove('input-error');
    var next = input.nextElementSibling;
    if (next && next.classList.contains('field-error')) {
      next.textContent = '';
    }
  }

  /* ──────────────────────────────────────────────
     REGOLE DI VALIDAZIONE
     ────────────────────────────────────────────── */
  function validaRichiesto(input, label) {
    if (!input.value.trim()) {
      showError(input, label + ' non puo essere vuoto');
      return false;
    }
    clearError(input);
    return true;
  }

  function validaProvincia(input) {
    var val = input.value.trim();
    if (!/^[A-Za-z]{2}$/.test(val)) {
      showError(input, 'La provincia deve essere di 2 lettere (es. NA)');
      return false;
    }
    clearError(input);
    return true;
  }

  function validaNumeroCarta(input) {
    var cifre = input.value.replace(/\s+/g, '');
    if (!/^\d{13,19}$/.test(cifre)) {
      showError(input, 'Numero carta non valido (13-19 cifre)');
      return false;
    }
    clearError(input);
    return true;
  }

  function validaScadenza(input) {
    var match = /^(\d{2})\/(\d{2})$/.exec(input.value.trim());
    if (!match) {
      showError(input, 'Formato scadenza non valido (MM/AA)');
      return false;
    }
    var mese = parseInt(match[1], 10);
    var anno = 2000 + parseInt(match[2], 10);
    if (mese < 1 || mese > 12) {
      showError(input, 'Mese di scadenza non valido');
      return false;
    }
    var ora = new Date();
    var annoCorrente = ora.getFullYear();
    var meseCorrente = ora.getMonth() + 1;
    if (anno < annoCorrente || (anno === annoCorrente && mese < meseCorrente)) {
      showError(input, 'La carta risulta scaduta');
      return false;
    }
    clearError(input);
    return true;
  }

  function validaCvv(input) {
    if (!/^\d{3,4}$/.test(input.value.trim())) {
      showError(input, 'CVV non valido (3 o 4 cifre)');
      return false;
    }
    clearError(input);
    return true;
  }

  /* ──────────────────────────────────────────────
     VALIDAZIONE AL TERMINE DELL'INSERIMENTO (evento change) + AL SUBMIT
     ────────────────────────────────────────────── */
  var indirizzo   = form.querySelector('#indirizzo');
  var paese       = form.querySelector('#paese');
  var provincia   = form.querySelector('#provincia');
  var titolare    = form.querySelector('#titolare');
  var numeroCarta = form.querySelector('#numeroCarta');
  var scadenza    = form.querySelector('#scadenza');
  var cvv         = form.querySelector('#cvv');

  indirizzo.addEventListener('change', function () { validaRichiesto(indirizzo, 'Indirizzo'); });
  paese.addEventListener('change', function () { validaRichiesto(paese, 'Paese'); });
  provincia.addEventListener('change', function () { validaProvincia(provincia); });
  titolare.addEventListener('change', function () { validaRichiesto(titolare, 'Titolare carta'); });
  numeroCarta.addEventListener('change', function () { validaNumeroCarta(numeroCarta); });
  scadenza.addEventListener('change', function () { validaScadenza(scadenza); });
  cvv.addEventListener('change', function () { validaCvv(cvv); });

  form.addEventListener('submit', function (e) {
    var valido = true;
    valido = validaRichiesto(indirizzo, 'Indirizzo') && valido;
    valido = validaRichiesto(paese, 'Paese') && valido;
    valido = validaProvincia(provincia) && valido;
    valido = validaRichiesto(titolare, 'Titolare carta') && valido;
    valido = validaNumeroCarta(numeroCarta) && valido;
    valido = validaScadenza(scadenza) && valido;
    valido = validaCvv(cvv) && valido;

    if (!valido) {
      e.preventDefault();
    }
  });

})();
