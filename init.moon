
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
    fileType = tools.getExtension path

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

  





Mage