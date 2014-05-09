Q = require('q')
dir = require('node-dir')
exec = require('child_process').exec

GEM_ASSET_PATTERN = /gems\/([\w-\.]+)\/app\/assets\/javascripts$/i
GEM_ASSET_VENDOR_PATTERN = /gems\/([\w-\.]+)\/vendor\/assets\/javascripts$/i
GEMS_PATH_CMD = 'bundle exec ruby -e "print Gem.path.first"'

GemsAssetsData = class
  path: ->
    @_path

  dirs: ->
    @_dirs

  setPath: (path) ->
    @_path = path

  setDirs: (dirs) ->
    @_dirs = dirs

  isResolved: ->
    @_isResolved

  setAsResolved: ->
    @_isResolved = true

  resolve: ->
    deferred = Q.defer()
    return deferred.resolve() if @isResolved()

    child = exec(GEMS_PATH_CMD, (error, output) =>
      gemsPath = output + '/gems'
      dir.subdirs gemsPath, (error, subdirs) =>
        gemsDirs = subdirs.filter (dir) =>
          GEM_ASSET_PATTERN.test(dir) || GEM_ASSET_VENDOR_PATTERN.test(dir)

        @setPath(gemsPath)
        @setDirs(gemsDirs)
        @setAsResolved()

        deferred.resolve()
    ).on('exit', (code) ->
      child.kill()
      unless code is 0
        console.log "Child process exited with exit code #{code}"
    )

    deferred.promise

module.exports = GemsAssetsData
