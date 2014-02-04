pkg      = require '../../package'
color    = require '../color'
argparse = require './argparse'
optm     = require 'optimist'

cmdHelp = (cmd) ->
  argParser.showHelp cmd
  process.exit 1

defaultCommand = ->
  cmdHelp()

newInstance = (names...) ->
  cmdHelp 'create' if @h
  console.log 'create', @, arguments

runInstance = (name) ->
  cmdHelp 'run' if @h
  console.log 'run', @, arguments

addPlugin = (plugins...) ->
  cmdHelp 'add' if @h
  console.log 'add', @, arguments

removePlugin = (plugins...) ->
  cmdHelp 'remove' if @h
  console.log 'remove', @, arguments

searchPlugin = (plugin) ->
  cmdHelp 'search' if @h
  console.log 'search', @, arguments

showPlugin = (plugin) ->
  cmdHelp 'info' if @h
  console.log 'info', @, arguments

showHelp = (cmd) ->
  cmdHelp cmd

optShare =
  config:
    alias: 'c'
    default: 'config'
    desc: 'Load config file then apply command options'
  port:
    alias: 'p'
    default: '3000'
    desc: 'Specify a port to listen'

commands =
  _default:
    opts:
      help:
        alias: 'h'
        boolean: yes
        desc: 'Show this help manual'
    desc: "#{color('Note:').bold} Each _option_ can be placed before _command_ or after _argument_."
    fn: defaultCommand
  new:
    alias: 'create'
    opts:
      port: optShare.port
      path:
        default:
          router: 'router'
          client: 'client'
        desc: 'Paths to load code and files'
    args: '<_name_>...'
    desc: 'Create new instances'
    fn: newInstance
  run:
    alias: ['start', 'up']
    opts:
      port: optShare.port
      config: optShare.config
    args: '[_name_]'
    desc: 'Start an instance'
    fn: runInstance
  add:
    args: '<_plugin_>...'
    desc: 'Add plugins to current instance'
    fn: addPlugin
  remove:
    alias: ['rm', 'delete']
    args: '<_plugin_>...'
    desc: 'Remove plugins from current instance'
    fn: removePlugin
  search:
    alias: 'find'
    opts:
      local:
        alias: 'l'
        boolean: yes
        desc: 'Search in local repository'
      remote:
        alias: 'r'
        boolean: yes
        desc: 'Search in remote repository'
    args: '<_plugin_>...'
    desc: 'Search plugins in local or on the Internet'
    fn: searchPlugin
  info:
    args: '<_plugin_>'
    desc: 'Display the information of a plugin'
    fn: showPlugin
  help:
    args: '[_command_]'
    desc: 'Show help and options'
    fn: showHelp

banner = "#MANUAL#\n\n  Xir.js v#{pkg.version} by RixTox\n  Yet another Node.js web framework."

argParser = new argparse 'xir', commands, banner

exports.run = ->
  argParser.parse()
