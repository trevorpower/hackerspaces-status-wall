module.exports =
  jade:
    match: /\.js$/
    compileSync: (sourcePath, source) ->
      require('jade')
        .compile(source, {client: true})
        .toString()
        .replace('anonymous', require('path').basename(sourcePath, '.jade'))
