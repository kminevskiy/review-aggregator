// $(function () {
//   $('.result-name').on('click', function () {
//     var $this = $(this).data('target');

//     $('#results-modals').load('/team-players.html ' + $this, function (response, status, xhr) {
//         if (status == "success") {
//             $(this).modal('show');
//         }
//     });
//   });
// });

$(function () {
  $('.result-name').on('click', function () {
    var url = $(this).attr('href');

    $('.my-modal-cont').load(url, function (result) {
    $(this).modal('show');
  });
});