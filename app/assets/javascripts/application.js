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

//= require jquery.infinitescroll
//= require jquery.masonry.min
//= require bootstrap-sprockets
//= require bootstrap/modal
//= require bootstrap/dropdown
//= require turbolinks
//= require jquery.ui.all
//= require highcharts
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
        $('#alertid').remove();
    });

    $('#myCarousel').on('slid.bs.carousel', function () {
        createResponseForm();
    });

    $('.submitme').on('click',function(){
        // var url2 = $('.item.active').data('url');
        // console.log("rest");
        // console.log( "test " + url2);

        // var data_id = $('.item.active').data('id');

            var valuesToSubmit = $('.edit_tag').serialize();
            // console.log(valuesToSubmit);
            $.ajax({
                url: $('.edit_tag').attr('action'),
                data: valuesToSubmit,
                // dataType: "JSON"
            }).success(function(data){
                $('.edit_tag').trigger('submit.rails');
            });
            return false;
    });

    $('#show_graph').click(function(){
        $('#responses_chart').toggle("slow", function(){

        });
    });

});

function createResponseForm(){
    // console.log("loaded");
    var pathname = window.location.pathname;
    // var data_id = $('.item.active').data('id');
    taggings_data = $('.item.active').data('tagging');
    // my_url = '/students/'+data_id+'/show_response';
    my_url = pathname + '/show_response';
    $.ajax({
        type: 'GET',
        url: my_url,
        success: function()
        {
            // this.reset();
            // $('input[type="text"],textarea').val('');
            $("input#student_response_taglist").val(taggings_data);
            // return false;
        },
        error: function(){
            alert('Error occurred');
        }
    });
};
