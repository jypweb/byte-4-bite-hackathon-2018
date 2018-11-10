var registerSwitch = document.getElementById("registerSwitch");
var loginSwitch = document.getElementById("registerSwitch");
if (registerSwitch || loginSwitch) {
  $("#registerSwitch").click(function() {
    $("#login-view").hide();
    $("#signup-view").show();
  });

  $("#loginSwitch").click(function() {
    $("#signup-view").hide();
    $("#login-view").show();
  });
}
