async = require 'async'

syncDirectory = require './tasks/sync_with_directory'
syncWiki = require './tasks/sync_with_wiki'

task 'sync:directory', 'sync with the api directory', () ->
  syncDirectory () ->
    process.exit()

task 'sync:wiki', 'sync with the api directory', () ->
  syncWiki () ->
    process.exit()

task 'sync:all', 'sync with all sources', () ->
  async.series [syncDirectory, syncWiki], () ->
    process.exit()

