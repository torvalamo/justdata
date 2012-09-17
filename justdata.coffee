# Fuck scanners and lexers. Let's regex this bitch.

exports.parse = (file, levels = -1) ->
	file = file.trim().replace(/[\r\n]+/, '\n')
	
	return parseBlock file, levels

parseBlock = (block, levels) ->	
	# split by top level elements
	elements = block.split /[\n\s]*\n(?=\S)/
	
	# parse elements' name-value pairs and store in
	object = {}
	array = []
	for element in elements
		[name, value] = parseElement element, levels
		unless value
			array.push name
		else
			object[name] = value
	
	if array.length
		if Object.keys(object).length
			object._ = if array[1] then array else array[0]
		else
			return if array[1] then array else array[0]
	return object

parseElement = (element, levels) ->
	# split the element at newlines
	items = element.split /[\n\s]*\n/
	
	# then remove the first line, which is the header
	header = items.shift().trim()
	
	# if there are no children, return empty array
	return [header, false] unless items.length
	
	# there are children, find indent level
	indent = items[0].match /^\s+(?=\S)/
	indent = indent[0]
	
	# then strip the current indent from all elements
	elements = []
	for item in items
		if !item.indexOf indent # indent is at pos 0
			elements.push item.substr indent.length
		else # incorrect format
			throw new Error "Bad indentation at '#{item}'"
		
	elements = elements.join '\n'
	
	# do we parse the children as well?
	unless levels # no
		return [header, elements]
	else # yes
		return [header, parseBlock elements, --levels]