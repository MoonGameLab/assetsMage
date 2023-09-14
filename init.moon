
path = ...
love = love
filesystem = love.filesystem
ext = assert require path .. ".ext"
tools = assert require path .. ".tools"

-- config
conf = {
  debug: true
  delim: '/' or package.config\sub 1,1
}

Mage = {}

with Mage
  .loadAsset = (path, ...) ->
    assert path, "Path should not be nil."
    fileType = tools.getExt path

    if tools.exists ext.image, fileType
      return love.graphics.newImage path, ...
    elseif tools.exists ext.audio, fileType
      return love.audio.newSource path, ... or 'static'
    elseif tools.exists ext.font, fileType
      return love.graphics.newFont path, ...
    elseif tools.exists ext.video, fileType
      return love.graphics.newVideo path, ...
    else

      for k, v in pairs ext
        for i = 1, #ext[k]
          p = path .. '.' .. ext[k][i]
          info = love.filesystem.getInfo p
          if info
            if info.type == "file"
              return Mage.loadAsset p, ...
    
      print "AssetMage couldn't load the asset."

  .requireLib = (path,recurse,tbl,rename,except,isPackage,debugTab) ->
    assert filesystem.getInfo(path), "Path does not exist : "..path

    libTab = tbl or {}
    dir, libName = filesystem.getDirectoryItems path

    rename = rename or (tbl and tools.getWord or tools.removeExt)
    except = except or -> return false
    debugT = debugTab or ''

    if debugT == '' and conf.debug
      print "<==  AssetsMage DEBUG INFO   ==>"

    for _, file in ipairs dir
      if tools.isFile path..conf.delim..file
        libName = rename file
        if tools.getExt(file) == "lua" and file ~= "init.lua" and except(file) == false
          file = tools.removeExt file
          print type(require(path..conf.delim..file ))
          if type(require(path..conf.delim..file )) ~= 'boolean'
            libTab[libName] = require path .. conf.delim .. file
            if conf.debug
              print debugT.. "Loaded Module : " ..libName.. ' ('..path..conf.delim..file..') ...'
          else
            require path .. conf.delim .. file
            if conf.debug
              print debugT..libName..' is a non-returning lib !!!'
      else
        if isPackage
          pName = rename(file)
          if tools.isFile(path..conf.delim..file..conf.delim..'init.lua') and except(file) == false
            if type(require(path..conf.delim..file )) ~= 'boolean'
              libTab[pName] = require path .. conf.delim .. file
              if conf.debug
                print debugT.. "Loaded Package : " ..pName.. ' ('..path..conf.delim..file..') ...'
            else
              require path .. conf.delim .. file
              if conf.debug
                print debugT..' '..pName..' is a non-returning package !!!'
        else
          if recurse
            if tools.isFile(path..conf.delim..file..conf.delim..'init.lua')
              if conf.debug
                print debugT..path..conf.delim..file.."is ignored (as it's a package)"
            else
              if conf.debug
                print debugT.."Recursing.. "..path..conf.delim..file
              tools.mergeTabs libTab, Mage.requireLib path..delim..file,recurse,tbl,rename,except,isPackage,debugTab..'\t'
    return libTab

Mage