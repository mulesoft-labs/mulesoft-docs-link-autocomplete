$topic = []
$section = []
$name = []
$url = []
# input format : <pretty section name>, <topic title>, <filename>, <complete file path>


module.exports =
  selector: '.source.asciidoc'

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    #console.log 'old prefix' + prefix
    prefix = @getPrefix(editor, bufferPosition)
    return unless prefix?.length
    prefix = prefix.substr(5)    #get rid of 'link:''
    console.log 'new prefix = ' + prefix
    answers = []  #to hold indexes with results


    for listIndex of $topic
      if @matchWords($topic[listIndex], prefix)
        console.log 'found a match'
        suggestion =
          text: $url + '[' + $topic[listIndex] + ']' #'link:\cloudhub\cloudhub-overview[CloudHub Overview]' #print
          displayText: $topic[listIndex]  #Cloudhub Overview   #topic title
          leftLabel: $section[listIndex]  #'CloudHub'      #section
          rightLabel: $name[listIndex].substr(0, $name[listIndex].length-5) # 'cloudhub-overview'   #file name  less .adoc
          description: 'Internal links to other Docs'
        return([suggestion])


  loadCompletions: ->
    docData = fs.readFileSync('/Users/nearnshaw/.atom/packages/link-autocomplete/content_list.csv').toString()
    $lines = docData.split("\n")
    for i of $lines
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
