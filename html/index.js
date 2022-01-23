

$(function () {
  function menu(bool) {
    if (bool) {
      $("#menuContainer").show();
    } else {
      $("#menuContainer").hide();
    }
  }

  menu(false);

  window.addEventListener("message", function (event) {
    var item = event.data;
    if (item.type === "hotdogMenu") {
      if (item.status == true) {
        menu(true);
      } else {
        menu(false);
      }
    }
      
  });

  document.onkeyup = function (data) {
    if (data.which == 27) {
        $.post('https://curse-stand/exit', JSON.stringify({}));
        return
    }
  };
  
  
  
});


