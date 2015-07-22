
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
    console.log 'new prefix = ' + prefix
    suggestionList = []  #to hold indexes with results

    for listIndex of $topic
      if @matchWords($topic[listIndex], prefix)
        console.log 'found a match'
        suggestionList.push(@addSuggestion(listIndex))
    for listIndex of $topic
      if @matchWords($section[listIndex], prefix)
        console.log 'matches section name'
        suggestionList.push(@addSuggestion(listIndex))
    suggestionList

    # resultCompletions = []
    # for {value} in suggestionList
    #   resultCompletions = resultCompletions.concat(value) if Array.isArray(value)
    # resultCompletions
    #_.uniq(resultCompletions)



  addSuggestion: (listIndex) ->
    suggestion =
      text: $url[listIndex] + '[' + $topic[listIndex] + ']' #'link:\cloudhub\cloudhub-overview[CloudHub Overview]' #print
      replacementText: "cualquiera"
      displayText: $topic[listIndex]  #Cloudhub Overview   #topic title
      leftLabel: $section[listIndex]  #'CloudHub'      #section
      rightLabel: $name[listIndex].substr(0, $name[listIndex].length-5) # 'cloudhub-overview'   #file name  less .adoc
      description: 'Internal links to other Docs'
    return(suggestion)


  loadCompletions: ->
    docData = fs.readFileSync(csvPath).toString()
    $lines = docData.split("\n")
    for i of $lines
      if $lines[i]
        $fields = $lines[i].split(',')
        $topic.push($fields[0])
        $section.push($fields[1])
        $name.push($fields[2])
        $url.push($fields[3])
    console.log 'csv list has ' + $lines.length + ' entries'
    console.log $name[0]
    console.log $section[3]

  getPrefix: (editor, bufferPosition) ->
    # Whatever your prefix regex might be
    regex = /\blink:.+/
    # Get the text for the line up to the triggered buffer position
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    # Match the regex to the line, and return the match
    line.match(regex)?[0] or ''


  matchWords: (topic, prefix) ->
    topic = topic.toLowerCase()
    console.log 'comparing topic ' + topic + ' with prefix ' + prefix
    return true if topic.indexOf(prefix) > -1

  onDidInsertSuggestion: ({editor, triggerPosition}) ->
    atom.commands.dispatch(atom.views.getView(editor), 'snippets:expand')
