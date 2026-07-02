/**
 * Kick Off — profilo.js
 * Gestisce: toggle del form "Modifica informazioni", validazione dei campi
 */
(function () {
  'use strict';

  /* ──────────────────────────────────────────────
     TOGGLE FORM DI MODIFICA
     ────────────────────────────────────────────── */
  var profiloInfo    = document.getElementById('profiloInfo');
  var profiloActions = document.getElementById('profiloActions');
  var form            = document.getElementById('modificaProfiloForm');
  var btnModifica      = document.getElementById('modificaProfiloBtn');
  var btnAnnulla        = document.getElementById('annullaModificaBtn');

  function mostraForm() {
    if (profiloInfo) profiloInfo.style.display = 'none';
    if (profiloActions) profiloActions.style.display = 'none';
    if (form) form.style.display = 'flex';
  }

  function nascondiForm() {
    if (profiloInfo) profiloInfo.style.display = 'flex';
    if (profiloActions) profiloActions.style.display = 'flex';
    if (form) form.style.display = 'none';
  }

  if (btnModifica) {
    btnModifica.addEventListener('click', mostraForm);
  }
  if (btnAnnulla) {
    btnAnnulla.addEventListener('click', function () {
      nascondiForm();
    });
  }

  /* ──────────────────────────────────────────────
     VALIDAZIONE FORM DI MODIFICA
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

  function validaRichiesto(input, label) {
    if (!input.value.trim()) {
      showError(input, label + ' non puo essere vuoto');
      return false;
    }
    clearError(input);
    return true;
  }

  function validaProvincia(input) {
    if (!/^[A-Za-z]{2}$/.test(input.value.trim())) {
      showError(input, 'La provincia deve essere di 2 lettere (es. NA)');
      return false;
    }
    clearError(input);
    return true;
  }

  if (form) {
    var nome      = form.querySelector('#nome');
    var cognome   = form.querySelector('#cognome');
    var indirizzo = form.querySelector('#indirizzo');
    var paese     = form.querySelector('#paese');
    var provincia = form.querySelector('#provincia');

    // Validazione al termine dell'inserimento di ogni campo (evento change)
    nome.addEventListener('change', function () { validaRichiesto(nome, 'Nome'); });
    cognome.addEventListener('change', function () { validaRichiesto(cognome, 'Cognome'); });
    indirizzo.addEventListener('change', function () { validaRichiesto(indirizzo, 'Indirizzo'); });
    paese.addEventListener('change', function () { validaRichiesto(paese, 'Paese'); });
    provincia.addEventListener('change', function () { validaProvincia(provincia); });

    form.addEventListener('submit', function (e) {
      var valido = true;
      valido = validaRichiesto(nome, 'Nome') && valido;
      valido = validaRichiesto(cognome, 'Cognome') && valido;
      valido = validaRichiesto(indirizzo, 'Indirizzo') && valido;
      valido = validaRichiesto(paese, 'Paese') && valido;
      valido = validaProvincia(provincia) && valido;

      if (!valido) {
        e.preventDefault();
      }
    });
  }

})();
