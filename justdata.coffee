exports.parse = (file, options) ->
	options          = options || {}
	options.combined = !!options.combined
	options.ordered  = !!options.ordered
	options.ignored  = !!options.ignored
	levels           = -1 if typeof options.levels == 'undefined'
	
	file = file.replace /[\r\n]+(\s+[\r\n]+)?/, '\n'
	
	return parseBlock file, options, '', levels

parseBlock = (block, options, indent, levels) ->
	# split the block at the head of every item on this indent level
	block = block.split new RegExp "\\n#{ indent }(?=\\S)"
	array = []
	object = {}
	for element in block
		# split the element lines and remove parent indent level
		element = element.split new RegExp "\\n#{ indent }"
		head = element.shift()
		unless element.length # it's a leaf
			array.push head unless Object.keys(object).length && options.ignored
			continue
		[newindent] = element[0].match /\s+/
		element[0] = element[0].substr newindent.length
		element = element.join '\n'
		levels--
		if levels
			element = parseBlock element, options, newindent, levels
		else
			element = element.split new RegExp "\\n#{ newindent }"
			element = element.join '\n'
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
	if options.combined
		array = [item for item in array when typeof item == 'string']
		array.unshift object if Object.keys(object).length
	unless array.length # if array is empty, then there must be objects
		return object
	unless 1 < array.length # don't return as array if there are no siblings
		return array[0]