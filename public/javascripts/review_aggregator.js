$(function () {
  var $results = $("#results ul"),
      $search = $("#search-section"),
      $modal = $("#modal");

  if ( $results.length ) {
    $search.css("top", "15%");
  } else $search.css("top", "50%");

  function renderModalDetails (business_object) {
    var modal_template = Handlebars.templates.modal;
    $modal.find("ul").remove();
    $modal.append(modal_template(business_object));
  }

  function getBusinessDetails(biz_id) {
    $.ajax({
      url: "/view/" + biz_id + "/obj.json",
      data: biz_id,
      success: function ( returned_data ) {
        renderModalDetails(returned_data);
      }
    })
  }

  $results.on("click", "a", function ( event ) {
    var $current_business = $(this).attr("id");
    event.preventDefault();
    $modal.fadeIn();
    getBusinessDetails($current_business);
  });

  $("#close-modal").on("click", function () {
    $modal.fadeOut();
  });


});
