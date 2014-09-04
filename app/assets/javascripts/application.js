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
// require turbolinks
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

    $("#dialog-wrong").dialog({
        autoOpen: false,
        dialogClass:"dialog-wrong",
        width: 550,
        show: {
            effect: "blind",
            duration: 1000
        },
        hide: {
            effect: "explode",
            duration: 500
        }
    });

    $("#dialog-correct").dialog({
        autoOpen: false,
        dialogClass:"dialog-correct",
        width: 550,
        show: {
            effect: "blind",
            duration: 1000
        },
        hide: {
            effect: "explode",
            duration: 500
        }
    });

    appendPreRegistrationMessage();


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

    $( "#student-tabs" ).tabs({
      beforeLoad: function( event, ui ) {
        ui.jqXHR.error(function() {
          ui.panel.html(
            "Couldn't load this tab. We'll try to fix this as soon as possible. " +
            "If this wouldn't be a demo." );
        });
      }
    });

    // to clear up an error form in students
    // $('.remove_me').click(function(){
        // $("#tabs-errors").html("");
    // });

    // been moved to show_selected.jserb
    // $('#myCarousel').on('slid.bs.carousel', function () {
    //     console.log("tes");
    //     createResponseForm();
    // });


    $('.submitme').on('click',function(){
        // console.log("test");
        // var serializedArray = $("input:checked").serializeArray();
        // var itemIdsArray = [];

        // for (var i = 0; i < serializedArray.length; i++) {
        //    itemIdsArray.push(serializedArray[i]['value']);
        // }
        // console.log(itemIdsArray);
        var tag_array = $('input:checked').valList().split(',');
        // $('input:checked').valList()
        // alert(tag_array);

        var pathname = window.location.pathname;
        $.ajax({
            type: "GET",
            url: pathname+'/show_selected',
            data: { tag_ids: tag_array },
            success: function()
            {
                // alert('Success occurred');
                // $("input#student_response_taglist").val(taggings_data);
            },
            error: function(){
                alert('Error occurred');
            }
        });


        // var valuesToSubmit = $('.edit_tag').serialize();
        // $.ajax({
        //     type: "POST",
        //     url: $('.edit_tag').attr('action'),
        //     data: valuesToSubmit,
        // }).success(function(data){
        //     $('.edit_tag').trigger('submit.rails');
        //     location.reload();
        // });
        return false;
    });



    var jumboHeight = $('.jumbotron2').outerHeight();
        function parallax(){
            var scrolled = $(window).scrollTop();
            $('.bg').css('height', (jumboHeight-scrolled) + 'px');
        }

        $(window).scroll(function(e){
            parallax();
        });

        setInterval(function(){
            $('.alert').slideUp('slow', function(){
               $(this).remove();
            });
        }, 2000);

        $('#show_graph').on('click',function(e)
        {
            e.preventDefault();
            $('#responses_chart').toggle("show", function(){
                console.log("add");
                addChart();
            });
        });

});

function appendPreRegistrationMessage(){
    var dial =  "<div><br/><p><b>Dearest User:</b> <br />We currently do not support email confirmations and password resets. "+
                "Please make sure you write down your password and email. "+
                "You can register with any email you wish (even a fake one!!) as long as it is unique in our database."+
                "</p></div>";
    $(dial).appendTo('#registration-message');
}


function removeErrorExplanation(){
    setInterval(function(){
        $('#error_explanation').slideUp('slow', function(){
            $(this).remove();
        });
    }, 2500);
};

function createResponseForm(){
    // console.log("loaded");
    var pathname = window.location.pathname;
    // var data_id = $('.item.active').data('id');
    taggings_data = $('.item.active').data('tagging');
    // my_url = '/students/'+data_id+'/show_response';
    my_url = pathname + '/show_response';
    // console.log(taggings_data);
    $.ajax({
        type: 'GET',
        url: my_url,
        success: function()
        {
            $("input#student_response_taglist").val(taggings_data);
        },
        error: function(){
            alert('Error occurred');
        }
    });
};

(function( $ ){
      $.fn.valList = function(){
            return $.map( this, function (elem) {
                  return elem.value || "";
            }).join( "," );
      };
      $.fn.idList = function(){
            return $.map( this, function (elem) {
                  return elem.id || "";
            }).join( "," );
      };
})( jQuery );



function addChart(){
    var pathname = window.location.pathname;
    // console.log(pathname);
    data_path = pathname+"?datas=datas";
    // '/students/1/show_summary?datas=datas'
    $.getJSON(data_path, null, function(data)
    {
        bar_chart("responses_chart", data);
    });
}

function processChartData(data){
    results = [];
    var seriesData = [];
    var xCategories = [];
    var i, cat;
    for(i = 0; i < data.length; i++){
        cat = data[i].unit;
        if(xCategories.indexOf(cat) === -1){
            xCategories[xCategories.length] = cat;
        }
    }
    for(i = 0; i < data.length; i++){
        if(seriesData){
          var currSeries = seriesData.filter(function(seriesObject){ return seriesObject.name == data[i].status;});
          if(currSeries.length === 0){
              currSeries = seriesData[seriesData.length] = {name: data[i].status, data: []};
          } else {
              currSeries = currSeries[0];
          }
          var index = currSeries.data.length;
          currSeries.data[index] = data[i].val;
        } else {
           seriesData[0] = {name: data[i].status, data: [data[i].val]}
        }
    }
    results.push(seriesData, xCategories);
    return results;
}

function bar_chart(div,data){

    results = processChartData(data);
    xCategories = results[1];
    seriesData = results[0];

    new Highcharts.Chart({
                chart: {
                    type: 'column',
                    renderTo: div },
                title: { text: 'Responses' },
                xAxis: {
                    categories: xCategories
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: 'Percentage'
                    }
                },
                plotOptions:{
                    column:{
                        stacking: 'normal',
                        dataLabels:
                        {
                            enabled: true,
                            color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                            style: {
                                textShadow: '0 0 3px black, 0 0 3px black'
                            },
                            formatter: function() {
                                 if(this.y > (0)) {
                                    return this.y;
                                }else{
                                    return null;
                                }
                            }
                        }
                    }
                },
                tooltip: {
                  formatter: function () {
                    return '<b>' + this.series.name + ':</b> ' +
                             + Highcharts.numberFormat(this.y,1, '.', ',') + '%';
                  }
                },
                series: seriesData
            });
}
