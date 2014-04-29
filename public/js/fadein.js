$(window).bind('load', function () {
  $('.starter-template')
    .css({ opacity: 0 })
    .velocity({ opacity: 1 }, { duration: 1000 });
});
