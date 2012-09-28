// Generated by CoffeeScript 1.3.3
(function() {
  var castrate, parse, properties, push;

  exports.parse = function(file, levels) {
    if (levels == null) {
      levels = -1;
    }
    file = file.trim().replace(/[\r\n]+/, '\n');
    return parse(file, levels);
  };

  push = Array.prototype.push;

  parse = function(block, levels) {
    var array, element, elements, header, indent, item, items, _i, _j, _len, _len1;
    elements = block.split(/[\n\s]*\n(?=\S)/);
    array = [];
    castrate(array);
    for (_i = 0, _len = elements.length; _i < _len; _i++) {
      element = elements[_i];
      items = element.split(/[\n\s]*\n/);
      header = items.shift().trim();
      if (!items.length) {
        push.call(array, header);
      } else {
        if (header === 'length') {
          throw new Error("length is a reserved word and cannot be used as a name");
        }
        indent = items[0].match(/^\s+(?=\S)/)[0];
        element = [];
        for (_j = 0, _len1 = items.length; _j < _len1; _j++) {
          item = items[_j];
          if (!item.indexOf(indent)) {
            element.push(item.substr(indent.length));
          } else {
            throw new Error("Bad indentation at '" + item + "'");
          }
        }
        element = element.join('\n');
        if (levels) {
          array[header] = parse(element, levels - 1);
        } else {
          array[header] = element;
        }
      }
    }
    return array;
  };

  properties = Object.getOwnPropertyNames(Array.prototype);

  properties.splice(properties.indexOf('length'), 1);

  castrate = function(array) {
    properties.forEach(function(e) {
      Object.defineProperty(array, e, {
        set: function(v) {
          Object.defineProperty(this, e, {
            set: void 0
          });
          return Object.defineProperty(this, e, {
            configurable: false,
            enumerable: true,
            value: v,
            writable: true
          });
        },
        configurable: true
      });
    });
  };

}).call(this);
