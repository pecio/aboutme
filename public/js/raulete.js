$(window).bind('load', function () {
  $('.starter-template')
    .animate({ opacity: 1 }, { duration: 1000 });
});

$(document).ready(function () {
  if (document.cookie.replace(/(?:(?:^|.*;\s*)cookiesAlertShown\s*\=\s*([^;]*).*$)|^.*$/, "$1") !== "true") {
    $('#alert-cookies').show();
  document.cookie = "cookiesAlertShown=true; expires=Fri, 31 Dec 9999 23:59:59 GMT; path=/";
  }
});
