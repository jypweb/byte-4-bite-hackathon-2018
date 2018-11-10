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

  var signupPages = $(".signup-page");

  $("#backBtn").click(function() {
    var prevPageIndex = $(".signup-page.active").index() - 1;
    signupPages.removeClass('active');
    signupPages.eq(prevPageIndex).addClass('active');
    $("#nextBtn").show();
    if (prevPageIndex == 0) {
      $("#backBtn").hide();
    }
  });

  $("#nextBtn").click(function() {
    var nextPageIndex = $(".signup-page.active").index() + 1;
    $("#backBtn").show();
    signupPages.removeClass('active');
    signupPages.eq(nextPageIndex).addClass('active');
    if (nextPageIndex == signupPages.length - 1) {
      $("#nextBtn").hide();
    }
  });

  $("#new_user").submit(function(e) {
    e.preventDefault();
    var required = $("#new_user input[required]");
    var errors = false;
    for (var x=0; x < required.length; x++) {
      if (required.eq(x).val() == "") {
        errors = true;
      }
    }
    if (errors) {
      showErrorMessage("Please fill out all required signup fields");
    } else {
      this.submit();
    }
  })
}
