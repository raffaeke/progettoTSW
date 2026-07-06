/**
 * assistenzaClienti.js
 * Gestisce: validazione dei form di assistenza, auto-scroll della cronologia
 */
(function () {
  'use strict';

  /* ──────────────────────────────────────────────
     AUTO-SCROLL CRONOLOGIA MESSAGGI
     ────────────────────────────────────────────── */
  var waBody = document.getElementById('waBody');
  if (waBody) {
    waBody.scrollTop = waBody.scrollHeight;
  }

  /* ──────────────────────────────────────────────
     VALIDAZIONE FORM (nuovo ticket / risposta)
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

  function validaMessaggio(campo) {
    if (!campo.value.trim()) {
      showError(campo, 'Il messaggio non puo essere vuoto');
      return false;
    }
    clearError(campo);
    return true;
  }

  function collegaValidazione(form, campo) {
    if (!form) return;
    // Validazione al termine dell'inserimento
    campo.addEventListener('change', function () { validaMessaggio(campo); });
    // Validazione al submit
    form.addEventListener('submit', function (e) {
      if (!validaMessaggio(campo)) {
        e.preventDefault();
        campo.focus();	//settiamo la tastiera del cliente dove è stato trovato l errore
      }
    });
  }

  var nuovoTicketForm = document.getElementById('nuovoTicketForm');
  if (nuovoTicketForm) {
    collegaValidazione(nuovoTicketForm, nuovoTicketForm.querySelector('[name="testoMessaggio"]'));
  }

  var rispondiForm = document.getElementById('rispondiForm');
  if (rispondiForm) {
    collegaValidazione(rispondiForm, rispondiForm.querySelector('[name="testoMessaggio"]'));
  }

})();
