/**
 * auth.js
 * Gestisce: validazione dei form di login e registrazione
 */
(function () {
  'use strict';

  var EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

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

  function validaRichiesto(input, label) {
    if (!input.value.trim()) {
      showError(input, label + ' non puo essere vuoto');
      return false;
    }
    clearError(input);
    return true;
  }

  function validaEmail(input) {
    if (!input.value.trim()) {
      showError(input, 'Email non puo essere vuota');
      return false;
    }
    if (!EMAIL_REGEX.test(input.value.trim())) {
      showError(input, 'Formato email non valido');
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

  function validaPassword(input) {
    if (!input.value || input.value.length < 6) {
      showError(input, 'La password deve avere almeno 6 caratteri');
      return false;
    }
    clearError(input);
    return true;
  }

  function validaConferma(confermaInput, passwordInput) {
    if (confermaInput.value !== passwordInput.value || !confermaInput.value) {
      showError(confermaInput, 'Le password non coincidono');
      return false;
    }
    clearError(confermaInput);
    return true;
  }

  /* ──────────────────────────────────────────────
     LOGIN
     ────────────────────────────────────────────── */
  var loginForm = document.getElementById('loginForm');
  if (loginForm) {
    var loginEmail    = loginForm.querySelector('#email');
    var loginPassword = loginForm.querySelector('#password');

    // Validazione al termine dell'inserimento
    loginEmail.addEventListener('change', function () { validaEmail(loginEmail); });
    loginPassword.addEventListener('change', function () { validaRichiesto(loginPassword, 'Password'); });

    // Validazione al submit
    loginForm.addEventListener('submit', function (e) {
      var valido = true;
      valido = validaEmail(loginEmail) && valido;
      valido = validaRichiesto(loginPassword, 'Password') && valido;

      if (!valido) e.preventDefault();
    });
  }

  /* ──────────────────────────────────────────────
     REGISTRAZIONE
     ────────────────────────────────────────────── */
  var registrazioneForm = document.getElementById('registrazioneForm');
  if (registrazioneForm) {
    var nome             = registrazioneForm.querySelector('#nome');
    var cognome          = registrazioneForm.querySelector('#cognome');
    var email            = registrazioneForm.querySelector('#email');
    var password         = registrazioneForm.querySelector('#password');
    var confermaPassword = registrazioneForm.querySelector('#confermaPassword');
    var paese            = registrazioneForm.querySelector('#paese');
    var indirizzo        = registrazioneForm.querySelector('#indirizzo');
    var provincia        = registrazioneForm.querySelector('#provincia');

    // Validazione al termine dell'inserimento di ogni campo 
    nome.addEventListener('change', function () { validaRichiesto(nome, 'Nome'); });
    cognome.addEventListener('change', function () { validaRichiesto(cognome, 'Cognome'); });
    email.addEventListener('change', function () { validaEmail(email); });
    password.addEventListener('change', function () {
      validaPassword(password);
      if (confermaPassword.value) validaConferma(confermaPassword, password);
    });
    confermaPassword.addEventListener('change', function () { validaConferma(confermaPassword, password); });
    paese.addEventListener('change', function () { validaRichiesto(paese, 'Paese'); });
    indirizzo.addEventListener('change', function () { validaRichiesto(indirizzo, 'Indirizzo'); });
    provincia.addEventListener('change', function () { validaProvincia(provincia); });

    // Validazione al submit 
    registrazioneForm.addEventListener('submit', function (e) {
      var valido = true;
      valido = validaRichiesto(nome, 'Nome') && valido;
      valido = validaRichiesto(cognome, 'Cognome') && valido;
      valido = validaEmail(email) && valido;
      valido = validaPassword(password) && valido;
      valido = validaConferma(confermaPassword, password) && valido;
      valido = validaRichiesto(paese, 'Paese') && valido;
      valido = validaRichiesto(indirizzo, 'Indirizzo') && valido;
      valido = validaProvincia(provincia) && valido;

      if (!valido) e.preventDefault();
    });
  }

})();
