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
//= require jquery.ui.all
//= require jquery.infinitescroll
//= require jquery.masonry.min
//= require bootstrap-sprockets
//= require bootstrap/modal
//= require bootstrap/dropdown
//= require turbolinks
//= require_tree .

// $('.carousel').carousel();
// $('.carousel').carousel({
//     interval: false
// });

//

$(function()
{
    var $container = $('.masonry-container');

    $container.masonry({
        isFitWidth: true,
        // columnWidth: '.masonry-item',
        itemSelector: '.masonry-item'
        }).imagesLoaded(function(){
            $container.masonry('reload');
        });

    $container.infinitescroll({
            navSelector  : "nav.pagination",
            // selector for the paged navigation (it will be hidden)
            nextSelector : "nav.pagination a[rel=next]",
            // selector for the NEXT link (to page 2)
            itemSelector : ".masonry-container div.masonry-item",

        },
        //trigger Masonry as a callback
        function( newElements ) {

            var $newElems = $(newElements).css({opacity: 0});

            $newElems.imagesLoaded(function(){
                $newElems.animate({opacity: 1});
                $container.masonry('appended', $newElems, true);

            });
        }
    );

    $(window).scroll();

    // $( "#tabs" ).tabs();

    // $( "#tabs" ).tabs({ selected: $("#tabs").data("selected") });

    // console.log($("#tabs").attr("data-selected"));

    // $( "#tabs" ).tabs({ active: $("#tabs").data("selected") });


    $( "#tabs" ).tabs({
      beforeLoad: function( event, ui ) {
        ui.jqXHR.error(function() {
          ui.panel.html(
            "Couldn't load this tab. We'll try to fix this as soon as possible. " +
            "If this wouldn't be a demo." );
        });
      }
    });


    // $('#ui-id-2').click(function(){
    //     // $("#tab-2").append("<%= render :partial => 'form'%>");
    //     console.log(this)
    //     $("div#tab-2").html("<%= escape_javascript(render partial: 'form') %>");
    // });


    // $("#tabs").click(function(){
    //         $.ajax({
    //             dataType: 'html',
    //             type: 'get',
    //             url: $(this).attr('href'),
    //             success: function(data){
    //                        $("#test").html(data);
    //                      }
    //         })
    //      });

    $('.remove_me').click(function(){
        // console.log("I am called");
        $('#alertid').remove();
    });

    // $('.carousel-control')

    $('#myCarousel').on('slid.bs.carousel', function () {

        var idx = $('#myCarousel .item.active').index();
        var url = $('.item.active').data('url');
        // $('.item').load(url,function(result){
        //     $('#myCarousel').carousel(idx);
        // });

        console.log(url);
        var pathname = window.location.pathname;
        console.log(pathname);

        var data_id = $('.item.active').data('id');
        console.log(data_id);

        // my_url = '/students/'+data_id+'/show_response';
        my_url = pathname+'/show_response';

        $.ajax({
            type: 'GET',
            url: my_url,
            // data: { 'passed_stid': data_id },
            success: function()
            {
                // $("#student_response").html("<%= escape_javascript(render(:partial => 'shared/student_response_form')) %>");
                // console.log("est");
                return false;
            },
            error: function(){
                alert('Error occurred');
            }
        });

    });

    // $('#myCarousel').on('click', function(){
    //     console.log("clicked");
    // });

    $(window).load(function () {
        var url = $('.item.active').data('url');
        console.log('calling ' + url);
    });

    $('.submitme').on('click',function(){
            var valuesToSubmit = $('.edit_tag').serialize();
            $.ajax({
                url: $('.edit_tag').attr('action'),
                data: valuesToSubmit,
                // dataType: "JSON"
            }).success(function(data){
                $('.edit_tag').trigger('submit.rails');
            });
            return false;
    });

});

