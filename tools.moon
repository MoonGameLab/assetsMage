love = love
filesystem = love.filesystem

-- returns true if file.
isFile = (path) ->
  pathInfo = filesystem.getInfo(path)
  pathInfo and pathInfo.type == "file"

lastIndexOf = (str, char) ->
  for i = str\len!, 1, -1
    if str\sub(i, i) == char then return i
  return str\len! + 1

removeExt = (fileName) ->
  fileName\sub 1, lastIndexOf(fileName, '.') - 1

getExtension = (fileName) ->
  fileName\sub (lastIndexOf(fileName, '.') or #fileName) + 1

-- NOTE: Will overide the val of keys that exists in multiple tabs.
mergeTabs = (tab, ...) ->
  for _, i in ipairs {...}
    for k, j in pairs(i)
      tab[k] = j

exists = (tab, elem) ->
  for i, el in ipairs tab
    if el == elem
      return true
  false

getWord = (fileName) ->
  return string.match fileName\gsub ' ', '_', "[_%w]+"


{
  isFile: isFile
  lastIndexOf: lastIndexOf
  removeExt: removeExt
  getExt: getExtension
  mergeTabs: mergeTabs
  exists: exists
  getWord: getWord
}