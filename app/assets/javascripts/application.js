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
//= require d3
//= require d3.layout.cloud
//= require_tree .


$(function()
{
    $(window).resize(function(){
        d3.select('svg').remove();
        if ($('.ddd').length == 1){
            var w = $('.ddd').width();
            d3test(w, '.ddd');
         }
        else if ($('.logo-image').length == 1){
            var w = $('.logo-image').width();
            d3test(w, '.logo-image');
        }
        else if ($('.logo-cheechart').length == 1){
            var w = $('.logo-cheechart').width();
            d3test(w, '.logo-cheechart');
        }
    });

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



    // var jumboHeight = $('.jumbotron2').outerHeight();
    //     function parallax(){
    //         var scrolled = $(window).scrollTop();
    //         $('.bg').css('height', (jumboHeight-scrolled) + 'px');
    //     }

    //     $(window).scroll(function(e){
    //         parallax();
    //     });

        setInterval(function(){
            $('.alert').slideUp('slow', function(){
               $(this).remove();
            });
        }, 2000);

        removeErrorExplanation();

        $('#show_graph').on('click',function(e)
        {
            e.preventDefault();
            $('#responses_chart').toggle("show", function(){
                // console.log("add");
                addChart();
            });
        });

});

function appendPreRegistrationMessage(){
    var dial =  "<div><br/><p><b>Dearest User:</b> <br /><br />We currently do not support email confirmation and password reset. "+
                "Please make sure you write down your password and email! "+
                "You can register with any email you wish (even a <u>fake</u> one!!) as long as it is unique in our database."+
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


function d3test(w,classy){
    // var data = [{"text":"study","size":40},{"text":"motion","size":15},{"text":"forces","size":10},{"text":"electricity","size":15},{"text":"movement","size":10},{"text":"relation","size":5},{"text":"things","size":10},{"text":"force","size":5},{"text":"ad","size":5},{"text":"energy","size":85},{"text":"living","size":5},{"text":"nonliving","size":5},{"text":"laws","size":15},{"text":"speed","size":45},{"text":"velocity","size":30},{"text":"define","size":5},{"text":"constraints","size":5},{"text":"universe","size":10},{"text":"physics","size":120},{"text":"describing","size":5},{"text":"matter","size":90},{"text":"physics-the","size":5},{"text":"world","size":10},{"text":"works","size":10},{"text":"science","size":70},{"text":"interactions","size":30},{"text":"studies","size":5},{"text":"properties","size":45},{"text":"nature","size":40},{"text":"branch","size":30},{"text":"concerned","size":25},{"text":"source","size":40},{"text":"google","size":10},{"text":"defintions","size":5},{"text":"two","size":15},{"text":"grouped","size":15},{"text":"traditional","size":15},{"text":"fields","size":15},{"text":"acoustics","size":15},{"text":"optics","size":15},{"text":"mechanics","size":20},{"text":"thermodynamics","size":15},{"text":"electromagnetism","size":15},{"text":"modern","size":15},{"text":"extensions","size":15},{"text":"thefreedictionary","size":15},{"text":"interaction","size":15},{"text":"org","size":25},{"text":"answers","size":5},{"text":"natural","size":15},{"text":"objects","size":5},{"text":"treats","size":10},{"text":"acting","size":5},{"text":"department","size":5},{"text":"gravitation","size":5},{"text":"heat","size":10},{"text":"light","size":10},{"text":"magnetism","size":10},{"text":"modify","size":5},{"text":"general","size":10},{"text":"bodies","size":5},{"text":"philosophy","size":5},{"text":"brainyquote","size":5},{"text":"words","size":5},{"text":"ph","size":5},{"text":"html","size":5},{"text":"lrl","size":5},{"text":"zgzmeylfwuy","size":5},{"text":"subject","size":5},{"text":"distinguished","size":5},{"text":"chemistry","size":5},{"text":"biology","size":5},{"text":"includes","size":5},{"text":"radiation","size":5},{"text":"sound","size":5},{"text":"structure","size":5},{"text":"atoms","size":5},{"text":"including","size":10},{"text":"atomic","size":10},{"text":"nuclear","size":10},{"text":"cryogenics","size":10},{"text":"solid-state","size":10},{"text":"particle","size":10},{"text":"plasma","size":10},{"text":"deals","size":5},{"text":"merriam-webster","size":5},{"text":"dictionary","size":10},{"text":"analysis","size":5},{"text":"conducted","size":5},{"text":"order","size":5},{"text":"understand","size":5},{"text":"behaves","size":5},{"text":"en","size":5},{"text":"wikipedia","size":5},{"text":"wiki","size":5},{"text":"physics-","size":5},{"text":"physical","size":5},{"text":"behaviour","size":5},{"text":"collinsdictionary","size":5},{"text":"english","size":5},{"text":"time","size":35},{"text":"distance","size":35},{"text":"wheels","size":5},{"text":"revelations","size":5},{"text":"minute","size":5},{"text":"acceleration","size":20},{"text":"torque","size":5},{"text":"wheel","size":5},{"text":"rotations","size":5},{"text":"resistance","size":5},{"text":"momentum","size":5},{"text":"measure","size":10},{"text":"direction","size":10},{"text":"car","size":5},{"text":"add","size":5},{"text":"traveled","size":5},{"text":"weight","size":5},{"text":"electrical","size":5},{"text":"power","size":5}];

    var data = [
        {"text":"Articulation","size":40},
        {"text":"Auditory","size":15},
        {"text":"Babbling","size":10},
        {"text":"Motherese","size":15},
        {"text":"Bilingual","size":10},
        {"text":"Blending","size":15},
        {"text":"Cognition","size":10},
        {"text":"Communication","size":5},
        {"text":"Conjunction","size":5},
        {"text":"Consonant","size":85},
        {"text":"Decoding","size":5},
        {"text":"Deficit","size":5},
        {"text":"Echolalia","size":15},
        {"text":"Figurative","size":45},
        {"text":"Grammar","size":30},
        {"text":"Inferencing","size":5},
        {"text":"Information","size":25},
        {"text":"Intonation","size":10},
        {"text":"Jargon","size":10},
        {"text":"Labelling","size":25},
        {"text":"Language","size":90},
        {"text":"Larynx","size":5},
        {"text":"Lexicon","size":10},
        {"text":"Metalinguistics","size":10},
        {"text":"MLU","size":70},
        {"text":"Morphology","size":30},
        {"text":"Narrative","size":5},
        {"text":"Pharynx","size":45},
        {"text":"Phonation","size":40},
        {"text":"Phoneme","size":30},
        {"text":"Phonology","size":25},
        {"text":"Predicting","size":40},
        {"text":"Pragmatics","size":10},
        {"text":"Prosody","size":5},
        {"text":"Reading","size":10},
        {"text":"Reinforcement","size":10},
        {"text":"Referencing","size":70},
        {"text":"Resonance","size":30},
        {"text":"Respiration","size":15},
        {"text":"Segmenting","size":45},
        {"text":"Semantic","size":40},
        {"text":"Sensory","size":30},
        {"text":"Sequencing","size":25},
        {"text":"Social","size":40},
        {"text":"Sound","size":10},
        {"text":"Spatial","size":5},
        {"text":"Speech","size":15},
        {"text":"Spoonerisms","size":25},
        {"text":"Syllable","size":120},
        {"text":"Syntax","size":35},
        {"text":"Therapy","size":40},
        {"text":"Tangential","size":15},
        {"text":"Verbal","size":10},
        {"text":"Videofluoroscopy","size":15},
        {"text":"Visual","size":10},
        {"text":"Vocabulary","size":5},
        {"text":"Voiced","size":10},
        {"text":"Voiceless","size":35},
        {"text":"Vowel","size":50},
        {"text":"Word","size":85},
        {"text":"Labialization","size":25},
        {"text":"Epenthesis","size":25},
        {"text":"Fluency","size":85},
        {"text":"Linguadental","size":15},
        {"text":"Nasality","size":5},
        {"text":"Pitch","size":15},
        {"text":"Tongue","size":45},
        {"text":"Ankyloglossia","size":30},
        {"text":"Bilingual","size":15},
        {"text":"Pre-Literacy","size":25},
        {"text":"Awareness","size":25},
        {"text":"Rapid Automatic Naming","size":35},
        {"text":"Receptive language","size":5}
    ]

    var color = d3.scale.linear()
            .domain([0,1,2,3,4,5,6,10,15,20,100])
            .range(["#ddd", "#ccc", "#bbb", "#aaa", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);


    var fill = d3.scale.category20();
        d3.layout.cloud().size([w, 300])
            .words(data)
            // .rotate(0)
            .rotate(function() { return ~~(Math.random() * 2) * 90; })
            // .padding(5)
            .font("Impact")
            .fontSize(function(d) { return (d.size + 10 + Math.random()); })
            .on("end", draw)
            .start();

    function draw(words) {
        d3.select(classy).append("svg")
            .attr("width", w)
            .attr("height", 400)
            .append("g")
            .attr("transform", "translate(" + (w*0.5) +",200)")
            .selectAll("text")
            .data(words)
            .enter().append("text")
            .style("font-size", function(d) { return d.size + "px"; })
            .style("font-family", "Impact")
            // .style("fill", function(d, i) { return color(i); })
            .style("fill", function(d, i) { return fill(i); })
            .attr("text-anchor", "middle")
            .attr("transform", function(d) {
              return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
            })
            .text(function(d) { return d.text; });
    }

}
