$("#modal-form").submit(function() {
  close_order_modal();
});

function update_order_modal(options) {
  $("#order-title").html("Order #" + options.title);
  $("#order-status").html(options.status);
  $("#delivery-type").html(options.delivery_type);
  $("#modal-form").attr("action", options.action);
  $("#modal-cancel-btn").attr("href", options.cancel_link);
  $("#modal-order-list").html("");
  $("#order_comment_").val(options.comment);
  $("#status-change").val("");
  $(options.items).each(function() {
    $("#modal-order-list").append("<li>" + this.name + " &times; " + this.quantity + "</li>");
  });

  var button_value, confirm_message;
  switch (options.status.toLowerCase()) {
    case "pending":
      button_value = "Accept Order"
      confirm_message = "Are you sure you want to accept this order?";
      break;
    case "processing":
      button_value = "Complete Order";
      confirm_message = "Are you sure you want to mark this order as complete?";
      break;
    default:
      button_value="Accept Order"
      confirm_message = "Are you sure you want to accept this order?";
      break;
  }

  $("#submit-btn").attr("data-confirm", confirm_message);
  $("#submit-btn").val(button_value);
}

function show_order_modal() {
  $('#order-details').modal('show')
}

function close_order_modal() {
  $("#order-details").modal('hide');
}
