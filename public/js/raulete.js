$(window).bind('load', function () {
  $('.starter-template')
    .animate({ opacity: 1 }, { duration: 1000 });
});

$(document).ready(function () {
  if ($(window).width() < 768) {
    $('a.dropdown-toggle').attr('href', '#');
  }
});
