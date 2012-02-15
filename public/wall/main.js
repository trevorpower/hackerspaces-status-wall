(function() {

  jQuery(function() {
    return $.getJSON("http://chasmcity.sonologic.nl/spacestatusdirectory.php", function(directory) {
      return $.each(directory, function(name, url) {
        return $.getJSON(url, function(space) {
          var section;
          if (space.open != null) {
            if (space.open) {
              space['state'] = 'open';
              if (space.icon != null) space['state_icon'] = space.icon.open;
            } else {
              space['state'] = 'closed';
              if (space.icon != null) space['state_icon'] = space.icon.close;
            }
          } else {
            space['state'] = 'unknown';
            space['state_icon'] = '';
          }
          section = $($('#spacetile').render(space)).hide().appendTo('#list').fadeIn();
          $('#loading').remove();
          return section.mousemove(function(e) {
            $(this).css("background-position-x", -((e.pageX - 130) - section.offset().left) + "px");
            return $(this).css("background-position-y", -((e.pageY - 130) - section.offset().top) + "px");
          });
        });
      });
    });
  });

}).call(this);
