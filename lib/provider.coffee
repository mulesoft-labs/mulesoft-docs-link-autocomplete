
#IMPORTANT!!!!
#============================================
# please change the line below to the path of the CSV list in your system:
csvPath = "/Users/nearnshaw/.atom/packages/link-autocomplete/content_list.csv"
#============================================

# csv input format : <pretty section name>, <topic title>, <filename>, <complete file path>
# eg: CloudHub, CloudHuv Overview, cloudhub-overview, http://www.mulesoft.org/documentation/display/current/cloudhub/cloudhub-overview

fs = require 'fs'

$topic = []
$section = []
$name = []
$url = []

module.exports =
  selector: '.source.asciidoc'
  inclusionPriority: 1
  excludeLowerPriority: true

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    #console.log 'old prefix' + prefix
    prefix = @getPrefix(editor, bufferPosition)
    return unless prefix?.length
    prefix = prefix.substr(5)    #get rid of 'link:''
    #console.log 'new prefix = ' + prefix
    suggestionList = []  #to hold indexes with results
    #triggerPosition = [bufferPosition.row, 0]

    for listIndex of $topic
      if @matchWords($topic[listIndex], prefix)
        #console.log 'found a match'
        suggestionList.push(@addSuggestion(listIndex, prefix))
    for listIndex of $topic
      if @matchWords($section[listIndex], prefix)
        #console.log 'matches section name'
        suggestionList.push(@addSuggestion(listIndex, prefix))
    suggestionList

    # resultCompletions = []
    # for {value} in suggestionList
    #   resultCompletions = resultCompletions.concat(value) if Array.isArray(value)
    # resultCompletions
    #_.uniq(resultCompletions)



  addSuggestion: (listIndex, prefix) ->
    #console.log 'BEFORE ------------'
    #console.log suggestion
    suggestion =
      text: $url[listIndex] + '[' + $topic[listIndex] + ']' #'link:\cloudhub\cloudhub-overview[CloudHub Overview]' #print
      displayText: $topic[listIndex]  #Cloudhub Overview   #topic title
      leftLabel: $section[listIndex]  #'CloudHub'      #section
      rightLabel: $name[listIndex].substr(0, $name[listIndex].length-5) # 'cloudhub-overview'   #file name  less .adoc
      description: 'Internal links to other Docs'
      replacementPrefix: prefix
    #console.log 'AFTER ------------'
    #console.log suggestion
    return(suggestion)


  loadCompletions: ->
    docData = fs.readFileSync(csvPath).toString()
    $lines = docData.split("\n")
    for i of $lines
      if $lines[i]
        $fields = $lines[i].split(/\s*,\s*/)
        $topic.push($fields[0])
        $section.push($fields[1])
        $name.push($fields[2])
        $url.push($fields[3])
    console.log 'csv list has ' + $lines.length + ' entries'
    console.log $name[0]
    #console.log $section[3]
    #console.log $url

  getPrefix: (editor, bufferPosition) ->
    # Whatever your prefix regex might be
    #regex = /\blink:.+(?!.*link:.)/
    regex = /.*(\blink:.+)$/
    # Get the text for the line up to the triggered buffer position
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    # Match the regex to the line, and return the match
    matches = line.match(regex)
    #console.log "PREFIX #{matches?[1]}"
    return matches?[1] or ''

  matchWords: (topic, prefix) ->
    topic = topic.toLowerCase()
    console.log 'comparing topic ' + topic + ' with prefix ' + prefix
    return true if topic.indexOf(prefix) > -1
###
  onDidInsertSuggestion: ({editor, triggerPosition}) ->
    console.log 'INSERT!!!'
    console.log 'OLD triggerPosition: ' + triggerPosition
    line = editor.getTextInRange([triggerPosition.row, 0], [triggerPosition.row, triggerPosition.column])
    prefixStart =line.search(/\blink:.+/)
    triggerPosition = [triggerPosition.row, prefixStart]
    console.log 'NEW triggerPosition: ' + triggerPosition
    atom.commands.dispatch(atom.views.getView(editor), 'snippets:expand')
###
