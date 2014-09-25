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
//= require jquery.ui.all
//= require highcharts
//= require d3
//= require d3.layout.cloud
//= require_tree .


$(function()
{

    resizeD3graphs();

    appendFeedbackDialogs();

    appendPreRegistrationMessage();

    setMansonryView();

    $(window).scroll();

    setupTabs();

    generateResponseFormSelectedContent();

    removeErrorExplanation();

    setGraphonClick();

    setInterval(function(){
        $('.alert').slideUp('slow', function(){
            $(this).remove();
        });
    }, 10000);

});


function setMansonryView(){
    var $container = $('.masonry-container');

    $container.masonry({
        isFitWidth: true,
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
        function( newElements ) {

            var $newElems = $(newElements).css({opacity: 0});

            $newElems.imagesLoaded(function(){
                $newElems.animate({opacity: 1});
                $container.masonry('appended', $newElems, true);

            });
        }
    );
}

function generateResponseFormSelectedContent(){
    $('.submitme').on('click',function(){

        var tag_array = $('input:checked').valList().split(',');
        var pathname = window.location.pathname;
        $.ajax({
            type: "GET",
            url: pathname+'/show_selected',
            data: { tag_ids: tag_array },
            success: function()
            {
                // alert('Success occurred');
            },
            error: function(){
                alert('Error occurred');
            }
        });
        return false;
    });
}

function setGraphonClick(){
    $('#show_graph').on('click',function(e)
    {
        e.preventDefault();
        $('#responses_chart').toggle("show", function(){
            addChart();
        });
    });
}

function setupTabs(){
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
}

function resizeD3graphs(){
    $(window).resize(function(){
        d3.select('svg').remove();
        if ($('.main_logo').length == 1){
            var w = $('.main_logo').width();
            d3DrawWordCloud(w, '.main_logo');
         }
        else if ($('.logo-image').length == 1){
            var w = $('.logo-image').width();
            d3DrawWordCloud(w, '.logo-image');
        }
        else if ($('.logo-cheechart').length == 1){
            var w = $('.logo-cheechart').width();
            d3DrawWordCloud(w, '.logo-cheechart');
        }
    });
}

function appendFeedbackDialogs(){
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
}

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
    }, 5500);
};

function createResponseForm(){
    var pathname = window.location.pathname;
    taggings_data = $('.item.active').data('tagging');
    my_url = pathname + '/show_response';
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
    data_path = pathname+"?datas=datas";
    $.getJSON(data_path, null, function(data)
    {
        createBarChart("responses_chart", data);
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

function createBarChart(div,data){

    results = processChartData(data);
    xCategories = results[1];
    seriesData = results[0];

    new Highcharts.Chart({
        chart: {
            type: 'column',
            renderTo: div },
        title: { text: 'Responses' },
        xAxis: { categories: xCategories },
        yAxis: {
                min: 0,
                title: { text: 'Percentage' }
        },
        plotOptions:{
            column:{
                stacking: 'normal',
                dataLabels:
                {
                    enabled: true,
                    color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                    style: { textShadow: '0 0 3px black, 0 0 3px black' },
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
                return '<b>' + this.series.name + ':</b> ' + Highcharts.numberFormat(this.y,1, '.', ',') + '%';
                }
            },
        series: seriesData
    });
}


function d3DrawWordCloud(w,classy){

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
            .rotate(function() { return ~~(Math.random() * 2) * 90; })
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
            .style("fill", function(d, i) { return fill(i); })
            .attr("text-anchor", "middle")
            .attr("transform", function(d) {
              return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
            })
            .text(function(d) { return d.text; });
    }

}
