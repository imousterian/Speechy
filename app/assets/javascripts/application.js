// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap
//= require turbolinks
//= require_tree .

// $('.carousel').carousel();
// $('.carousel').carousel({
//     interval: false
// });

$(function()
{
    $('#myCarousel').on('slid.bs.carousel', function (e) {

        console.log("test");
        var slideFrom = $(this).find('.active').index();
        var slideTo = $(e.relatedTarget).index();
        console.log(slideFrom + ' => ' + slideTo);

        // var el = $(this).find('.active > img').innerHTML();
        var el = $('.active > img').attr('src')
        console.log(el);
    });

});


