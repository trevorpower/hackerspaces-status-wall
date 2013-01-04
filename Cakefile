async = require 'async'

syncDirectory = require './tasks/sync_with_directory'
syncWiki = require './tasks/sync_with_wiki'
syncApis = require './tasks/sync_with_apis'
syncTwitter = require './tasks/sync_with_twitter'

task 'sync:directory', 'sync with the api directory', () ->
  syncDirectory () -> process.exit()

task 'sync:wiki', 'sync with the wiki', () ->
  syncWiki () -> process.exit()

task 'sync:apis', 'sync with status apis', () ->
  syncApis () -> process.exit()

task 'sync:twitter', 'sync with twitter', () ->
  syncTwitter () -> process.exit()

task 'sync:all', 'sync with all sources', () ->
  async.series [
      syncDirectory,
      syncWiki,
      syncApis,
      syncTwitter
    ], () -> process.exit()

