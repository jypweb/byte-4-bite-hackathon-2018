if ($(".image-checkbox").length) {
  $(".image-checkbox").on("click", function (e) {
    e.preventDefault();
    $(this).toggleClass('image-checkbox-checked');
    var $checkbox = $(this).find('input[type="checkbox"]');
    $checkbox.prop("checked",!$checkbox.prop("checked"))
  });
}
