exports.parse = (file, options) ->
	options          = options || {}
	options.combined = !!options.combined
	options.ordered  = !!options.ordered
	options.ignored  = !!options.ignored
	levels           = -1 if typeof options.levels == 'undefined'
	
	file = file.replace /\s*[\r\n]+(\s+[\r\n]+)?/, '\n'
	file = file.replace /\s*[\r\n\s]+$/, ''
	
	return parseBlock file, options, '', levels

parseBlock = (block, options, indent, levels) ->
	# split the block at the head of every element on this indent level
	block = block.split new RegExp "\\n#{ indent }(?=\\S)"
	console.log "L16: #{ JSON.stringify(block) }"
	array = []
	object = {}
	for element in block
		# split the element lines and remove parent indent level
		element = element.split new RegExp "\\n#{ indent }"
		# consume the parent line
		head = element.shift().trim()
		unless element.length # it's a leaf
			array.push head
			console.log "L26: #{head}"
			continue
		[newindent] = element[0].match /\s+/
		element[0] = element[0].substr newindent.length
		element = element.join '\n'
		levels--
		#if levels
		element = parseBlock element, options, newindent, levels
		#else
		#	element = element.split new RegExp "\\n#{ newindent }"
		#	element = element.join '\n'
		console.log "L33: #{head}: #{JSON.stringify(element)}"
		if object[head]
			unless object[head] instanceof Array
				object[head] = [object[head]]
			object[head].push element
		else
			object[head] = element
		if options.ordered || !options.combined
			obj = {}
			obj[head] = element
			array.push obj
	if options.ignored && Object.keys(object).length
		array = [item for item in array when typeof item != 'string']
	if options.combined || !options.ordered
		array = [item for item in array when typeof item == 'string']
		array.unshift object if Object.keys(object).length
	unless array.length # if array is empty, then there must be objects
		return object
	unless 1 < array.length # don't return as array if there are no siblings
		return array[0]
	return array