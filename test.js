// node test.js <file_name> [levels]

var jd = require('./justdata')
var fs = require('fs')

console.log(jd.parse(fs.readFileSync(process.argv[2], 'utf-8'), parseInt(process.argv[3], 10) || 0))
