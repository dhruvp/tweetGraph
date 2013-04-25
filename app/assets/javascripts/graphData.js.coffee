#graphData.js is used for the visualizations in the connections page. It uses d3.js to dynamically render the visualizations


Network = () ->

  #initial parameters
  width = 1000
  height = 1000
  allData= []
  curLinksData= []
  curNodesData= []
  linkedByIndex= {}
  startTime = 0
  endTime = 0

  nodesG= null
  linksG= null

  node= null
  link= null

  timer = null

  layout= "force"
 
  filter= "all"


  force= d3.layout.force()
  nodeColors= d3.scale.category20()

  #Initialize the tool tip object used when you hover over a node
  tooltip= Tooltip("vis-tooltip",230)

  charge = (node) -> -Math.pow(node.radius,2.0) / 2

  network = (selection, data) ->
    startTime= Number(new Date(data.nodes[0].time))
    endTime= Number(new Date(data.nodes[0].time))
    allData=setupData(data)
    #Name the html element svg
    vis=d3.select(selection).append("svg")
      .attr("width",width)
      .attr("height",height)
    #Give the id as the name for each node's html element
    linksG = vis.append("g").attr("id","links")
    nodesG = vis.append("g").attr("id","nodes")

    force.size([width,height])

    setLayout("force")
    setFilter("all")
    update()

  # update() is called everytime a parameter changes
  # and the network needs to be reset.
  update = () ->

    curNodesData= filterNodes(allData.nodes)
    curLinksData= filterLinks(allData.links, curNodesData)

    # reset nodes in force layout
    force.nodes(curNodesData)

    # enter / exit for nodes
    updateNodes()

    # always show links in force layout
    force.links(curLinksData)
    updateLinks()

    # start me up!
    force.start()

  network.toggleLayout = (newLayout) ->
    force.stop()
    setLayout(newLayout)
    update()

  # Public function to switch between filter options
  network.toggleFilter = (newFilter) ->
    force.stop()
    setFilter(newFilter)
    update()



  # called once to clean up raw data and switch links to
  # point to node instances
  # Returns modified data
  setupData = (data) ->
    # initialize circle radius scale
    countExtent = d3.extent(data.nodes, 
      (d) -> 
        return 1)
    circleRadius = d3.scale.sqrt().range([30, 40]).domain(countExtent)

    for n in data.nodes

      # add radius to the node so we can use it later
      if n.num_connections != undefined
        n.radius = circleRadius(n.num_connections)
        # set initial x/y to values within the width/height
        # of the visualization
        #n.x = randomnumber=Math.floor(Math.random()*width)
        #n.y = randomnumber=Math.floor(Math.random()*height)
        n.tags=data.tags[n.id]
      else
        n.radius = circleRadius(1)
        #n.x = randomnumber=Math.floor(0.5*width)
        #n.y = randomnumber=Math.floor(0.5*height)


    # id's -> node objects
    nodesMap  = mapNodes(data.nodes)

    # switch links to point to node objects instead of id's
    data.links.forEach (l) ->
      l.source = nodesMap.get(l.source)
      l.target = nodesMap.get(l.target)

      # linkedByIndex is used for link sorting
      linkedByIndex["#{l.source.id},#{l.target.id}"] = 1

    data

  # Helper function to map node id's to node objects.
  # Returns d3.map of ids -> nodes
  mapNodes = (nodes) ->
    nodesMap = d3.map()
    nodes.forEach (n) ->
      number_time= Number(new Date(n.time))
      if number_time <startTime
        startTime = number_time
      if number_time > endTime
        endTime= number_time
      nodesMap.set(n.id, n)
    nodesMap

  # 'enter/exit display for nodes
  updateNodes = () ->
    ramp= d3.scale.linear().domain([startTime,endTime]).range(["blue","green"]);
    node = nodesG.selectAll("circle.node")
      .data(curNodesData, (d) -> d.id)

    node.enter().append("circle")
      .attr("class", "node")
      .attr("cx", (d) -> d.x)
      .attr("cy", (d) -> d.y)
      .attr("r", (d) -> d.radius)
      .style("fill", (d) -> ramp(Number(new Date(d.time))))
      .style("stroke", (d) -> strokeFor(d))
      .style("stroke-width", 1.0)


    node.on("mouseover", showDetails)
      .on("mouseout", hideDetails)

    node.exit().remove()

  # enter/exit display for links
  updateLinks = () ->
    link = linksG.selectAll("line.link")
      .data(curLinksData, (d) -> "#{d.source.id}_#{d.target.id}")
    link.enter().append("line")
      .attr("class", "link")
      .attr("stroke", "#555")
      .attr("stroke-opacity", 1)
      .attr("x1", (d) -> d.source.x)
      .attr("y1", (d) -> d.source.y)
      .attr("x2", (d) -> d.target.x)
      .attr("y2", (d) -> d.target.y)

    link.exit().remove()

  # Helper function that returns stroke color for
  # particular node.
  strokeFor = (d) ->
    d3.rgb(nodeColors(d.id)).darker().toString()


  # switches force to new layout parameters
  setLayout = (newLayout) ->
    layout = newLayout
    force.on("tick", forceTick)
      .charge(-200)
      #.charge((d)->-d.elapsedtime/10)
      #.linkDistance(200)
      #.friction(1)
      .linkDistance( (d) -> (d.target.elapsedtime)/1000)


  # tick function for force directed layout
  forceTick = (e) ->
    node
      .attr("cx", (d) -> d.x)
      .attr("cy", (d) -> d.y)

    link
      .attr("x1", (d) -> d.source.x)
      .attr("y1", (d) -> d.source.y)
      .attr("x2", (d) -> d.target.x)
      .attr("y2", (d) -> d.target.y)


 # Mouseover tooltip function
  showDetails = (d,i) ->
    clearTimeout (timer)
    event = d3.event
    if d.id!=0
      request = $.get '/tweetinfo/'+d.id

      request.success (data) ->
        content= data
        callTooltip(content,event)

    d3.select(this).style("stroke","black")
      .style("stroke-width", 2.0)

  callTooltip = (content, event) ->
    tooltip.showTooltip(content, event)


  # Mouseout function
  hideDetails = (d,i) ->
    timer = setTimeout ( ->
      tooltip.hideTooltip()
    ), 1500
    d3.select(this).style("stroke","black")
      .style("stroke-width", 0)


  # Removes nodes from input array
  # based on current filter setting.
  # Returns array of nodes
  filterNodes = (allNodes) ->
    filteredNodes=allNodes
    if filter!="all"
      filteredNodes=allNodes.filter (n) ->
        n.id==0 or filter in n.tags


    filteredNodes


  # Removes links from allLinks whose
  # source or target is not present in curNodes
  # Returns array of links
  filterLinks = (allLinks, curNodes) ->
    curNodes = mapNodes(curNodes)
    allLinks.filter (l) ->
      curNodes.get(l.source.id) and curNodes.get(l.target.id)


  # switches filter option to new filter
  setFilter = (newFilter) ->
    filter = newFilter


  return network


# Activate selector button
activate = (group, link) ->
  d3.selectAll("##{group} a").classed("active", false)
  d3.select("##{group} ##{link}").classed("active", true)

$ ->
  myNetwork = Network()
  d3.json '/graph.json', (json) ->
    myNetwork("#vis", json)

  d3.selectAll("#filters a").on "click", (d) ->
    newFilter = d3.select(this).attr("id")
    activate("filters", newFilter)
    myNetwork.toggleFilter(newFilter)

  $("#search_button").click ->
    $("#vis").empty()
    query= $("#search").val()
    url= '/graph/'+encodeURI(query)+'.json'
    d3.json url, (json) ->
      myNetwork("#vis", json)


