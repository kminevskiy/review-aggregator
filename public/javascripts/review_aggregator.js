$(function () {
  var $results = $("#results ul"),
      $search = $("#search-section");

  if ( $results.length ) {
    $search.css("top", "15%");
  } else $search.css("top", "50%");
});
