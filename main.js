(function() {

  alert("test");

  jQuery(function() {
    alert("test1");
    return alert("test");
  });

}).call(this);
