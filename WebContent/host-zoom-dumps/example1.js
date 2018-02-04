var labelType, useGradients, nativeTextSupport, animate;

(function() {
  var ua = navigator.userAgent,
      iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
      typeOfCanvas = typeof HTMLCanvasElement,
      nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
      textSupport = nativeCanvasSupport 
        && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
  //I'm setting this based on the fact that ExCanvas provides text support for IE
  //and that as of today iPhone/iPad current text support is lame
  labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
  nativeTextSupport = labelType == 'Native';
  useGradients = nativeCanvasSupport;
  animate = !(iStuff || !nativeCanvasSupport);
})();

var Log = {
  elem: false,
  write: function(text){
    if (!this.elem) 
      this.elem = document.getElementById('log');
    this.elem.innerHTML = text;
    this.elem.style.left = (500 - this.elem.offsetWidth / 2) + 'px';
  }
};


function init(){
  //init data
  var json = {
      'label': ['Incoming Traffic', 'Outgoing Traffic'],
      'values': [
      {
        'label': 'HOST X',
        'values': [20, 40]
      },
	  {
        'label': '',
        'values': []
      },
      {
        'label': '1',
        'values': [30, 10]
      },
      {
        'label': '2',
        'values': [38, 20]
      },
      {
        'label': '3',
        'values': [58, 10]
      },
      {
        'label': '4',
        'values': [55, 60]
      },
	  {
        'label': '5',
        'values': [55, 60]
      }, 
	  {
        'label': '6',
        'values': [55, 60]
      }, 
	  {
        'label': '7',
        'values': [55, 60]
      }, 
	  {
        'label': '8',
        'values': [55, 60]
      }, 
	  {
        'label': '9',
        'values': [55, 60]
      }, 
      {
        'label': '10',
        'values': [26, 40]
      }]
      
  };
  //end
  var json2 = {
      'values': [
      {
        'label': '1',
        'values': [10, 40]
      }, 
      {
        'label': '2',
        'values': [30, 40]
      }, 
      {
        'label': '3',
        'values': [55, 30]
      }, 
      {
        'label': '4',
        'values': [26, 40]
      }]
      
  };
    //init BarChart
    var barChart = new $jit.BarChart({
      //id of the visualization container
      injectInto: 'infovis',
      //whether to add animations
      animate: true,
      //horizontal or vertical barcharts
      orientation: 'vertical',
      //bars separation
      barsOffset: 20,
      //visualization offset
      Margin: {
        top:5,
        left: 5,
        right: 5,
        bottom:5
      },
      //labels offset position
      labelOffset: 5,
      //bars style
      type: useGradients? 'stacked:gradient' : 'stacked',
      //whether to show the aggregation of the values
      showAggregates:false,//
      //whether to show the labels for the bars
      showLabels:true,
      //labels style
      Label: {
        type: labelType, //Native or HTML
        size: 13,
        family: 'Arial',
        color: 'white'
      },
      //add tooltips
      Tips: {
        enable: true,
        onShow: function(tip, elem) {
          tip.innerHTML = "<b>" + elem.name + "</b>: " + elem.value + " Packets/s";
        }
      }
    });
    //load JSON data.
    barChart.loadJSON(json);
    //end
    var list = $jit.id('id-list'),
        button = $jit.id('update'),
        orn = $jit.id('switch-orientation');
    //update json on click 'Update Data'
    $jit.util.addEvent(button, 'click', function() {
      var util = $jit.util;
      if(util.hasClass(button, 'gray')) return;
      util.removeClass(button, 'white');
      util.addClass(button, 'gray');
      barChart.updateJSON(json2);
    });
    //dynamically add legend to list
    var legend = barChart.getLegend(),
        listItems = [];
    for(var name in legend) {
      listItems.push('<div class=\'query-color\' style=\'background-color:'
          + legend[name] +'\'>&nbsp;</div>' + name);
    }
    list.innerHTML = '<li>' + listItems.join('</li><li>') + '</li>';
}
