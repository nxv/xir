pkg = require '../package.json'
optm = require 'optimist'

options =
  config:
    alias: 'c'
    desc: 'Load config file, override command options'
  port:
    alias: 'p'
    default: '3000'
    desc: 'Specify a port to listen'
  path:
    default:
      router: 'router'
      client: 'client'
    desc: 'Paths to load code and files'
  help:
    alias: 'h'
    boolean: yes
    desc: 'Show this help manual'

# ANSI Terminal Colors.
bold = red = green = reset = ''
unless process.env.NODE_DISABLE_COLORS
  bold  = '\x1B[0;1m'
  under = '\x1B[0;4m'
  red   = '\x1B[0;31m'
  green = '\x1B[0;32m'
  reset = '\x1B[0m'

msg = """
#{bold}NAME#{reset}
  Xir.js v#{pkg.version} by RixTox
  Yet another Node.js web framework.

#{bold}SYNOPSIS#{reset}
  Start an instance inside it

      xir [#{under}options#{reset}]...

  Create a new instance or start an existing instance

      xir [#{under}options#{reset}]... <#{under}name#{reset}>
"""
argv = optm.usage(msg, options).argv

exports.run = ->
  return optm.showHelp() if argv.h
  console.log argv
