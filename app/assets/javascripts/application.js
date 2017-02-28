// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery
//= require turbolinks
//= require_tree .

$(document).ready(function() {
$('a[href*="#"]:not([href="#"])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html, body').animate({
          scrollTop: target.offset().top
        }, 1000);
        return false;
      }
    }
  });

      // $(".intro-header").vegas({
	// delay: 5000,
    // slides: [
        // { src: "/assets/back1.JPG" },
        // { src: "/assets/back2.JPG" },
        // { src: "/assets/back3.JPG" },
        // { src: "/assets/back4.JPG" },
        // { src: "/assets/back5.JPG" },
        // { src: "/assets/back6.jpg" },
        // { src: "/assets/back7.jpg" },
        // { src: "/assets/back8.jpg" },
        // { src: "/assets/back9.jpg" }
    // ],animation: 'kenburns'
// });
});