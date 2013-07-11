$ ->
	d3.json '/chart.json', (json) ->
		graph = new Rickshaw.Graph({
			width:900,
			height:500,
			element: document.querySelector("#chart"),
			series: [{
			     color: 'steelblue',
			     data: json
			}]
			})

		graph.render()

		hoverDetail = new Rickshaw.Graph.HoverDetail( {
			graph: graph
			})

		ticksTreatment = 'glow'

		xAxis = new Rickshaw.Graph.Axis.Time( {
			graph: graph,
			ticksTreatment: ticksTreatment
		} )

		xAxis.render()

		yAxis = new Rickshaw.Graph.Axis.Y( {
			graph: graph,
			ticksTreatment: ticksTreatment
		} )

		yAxis.render()

		# jQuery.noConflict()

		$('#slider').width(900)

		slider = new Rickshaw.Graph.RangeSlider({
	    graph: graph,
	    element: document.querySelector('#slider')
	  })




