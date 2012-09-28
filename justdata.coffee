exports.parse = (file, levels = -1) ->
	file = file.trim().replace /[\r\n]+/, '\n'
	return parse file, levels

#
# For use with the array storage objects, since their
# prototype functions are removed.
push = Array.prototype.push

#
# Parse the given block recursively through the amount of levels specified
parse = (block, levels) ->
	elements = block.split /[\n\s]*\n(?=\S)/
	# create a castrated array object
	array = []
	castrate array
	for element in elements
		# split by newlines
		items = element.split /[\n\s]*\n/
		header = items.shift().trim()
		unless items.length
			# no children
			push.call array, header
		else
			if header is 'length'
				throw new Error "length is a reserved word and cannot be used as a name"
			# find indent of children
			indent = items[0].match(/^\s+(?=\S)/)[0]
			element = []
			# strip the current indent from children
			for item in items
				if !item.indexOf indent # indent is at pos 0
					element.push item.substr indent.length
				else
					throw new Error "Bad indentation at '#{item}'"
			element = element.join '\n'
			if levels
				array[header] = parse element, levels - 1
			else
				array[header] = element
	return array

#
# For use with castrate
# Get list of array prototype functions
properties = Object.getOwnPropertyNames(Array.prototype)
# Remove length property, required
properties.splice(properties.indexOf('length'), 1)

#
# void castrate(array)
#
# Strip all the prototype functions of the array object.
# To manipulate it you should instead use
#   Array.prototype.theFunction.call(arrayObj, arg, ..)
# This is to avoid name collisions. Say you want a property called sort, but
# the config file doesn't define it. Looking it up would tell you that it is 
# defined, but it doesn't return a value that is expected. Instead it returns
# the array prototype function sort. That is why we undefine these names.
castrate = (array) ->
	properties.forEach (e) ->
		Object.defineProperty array, e, {
			# we need to switch on enumerable only after (if) the property is set,
			# so we make a setter for that purpose only
			set: (v) ->
				# once set, we remove the setter
				Object.defineProperty this, e, {
					set: undefined
				}
				# and make the property behave like normal
				Object.defineProperty this, e, {
					configurable: false,
					enumerable: true,
					value: v,
					writable: true
				},
			configurable: true
		}
		return
	return
