color = require '../color'
optimist = require 'optimist'

s_comd = '[_command_]'
s_opts = '[_option_]...'
s_args = '[_argumnet_]...'

c_title = (str) ->
  color(str).bold.blue
c_arg = (str) ->
  color(str).cyan.underline
c_err = (str) ->
  color(str).bold.red

errCmdNotFound = (cmd) ->
  console.error "#{c_err 'Error:'} Cannot find command #{c_arg cmd}"
errCmdConflict = (cmd, opt, conflict) ->
  console.error "#{c_err 'Error:'} Command #{c_arg cmd}#{helper opt} conflicts with command #{c_arg cmd}#{helper conflict}"

addColor = (str) ->
  str
  .replace(/_\w*?_/g, (str) ->
    c_arg(str.match(/_(\w*)_/)[1]))
  .replace(/#\w*?#/g, (str) ->
    c_title(str.match(/#(\w*)#/)[1]))

isEmpty = (obj) ->
  !if typeof obj == 'object'
    Object.keys(obj).length
  else
    obj?

module.exports = class ArgParser
  constructor: (@prefix, cmds, @banner) ->
    @cmds = buildCmds cmds
    @default = cmds._default if cmds._default
  parse: (argv) ->
    optimist.options @default.opts
    args = argv || process.argv[2..]
    argv = optimist.parse args
    cmd = argv._[0]
    opt = @cmds[cmd]
    errCmdNotFound cmd if !opt && cmd
    fn = opt && opt.fn || @default.fn
    optimist.options(opt.opts) if opt && opt.opts
    opts = optimist.parse args
    args = opt && opts._.slice 1 || opts._
    fn.apply opts, args
  help: (cmd) ->
    lines = []
    p = (l,n) -> lines.push "#{l}#{!n&&'\n'||''}"
    cmdHelper = (cmd, opt) =>
      cmd = "<#{cmd}#{('|' + a for a in opt.alias).join ''}>" if opt.alias
      "#{@prefix} #{cmd} #{s_opts} #{opt.args || s_args}"
    if cmd
      opt = @cmds[cmd]
      unless opt
        errCmdNotFound cmd
        process.exit 1
      p "#USAGE#"
      p "      #{cmdHelper cmd, opt}"
      p "  #{opt.desc}"
      unless isEmpty(@default.opts) || isEmpty(opt.opts)
        p "#OPTIONS#"
        max = []
        options = []
        space = '  '
        flatenOption = (key, val) ->
          name = "  --#{key}"
          alias = val.alias && ('-' + a for a in val.alias).join(' ') || ''
          desc = "-- #{val.desc}"
          defa = val.default && "\n$2   [default: #{JSON.stringify(val.default)}]" || ''
          option = [name, alias, desc, defa]
          for v, i in option
            l = v.length
            max[i] = l if l >= (max[i]||0)
          options.push option
        flatenOption key, val for key, val of opt.opts
        flatenOption key, val for key, val of @default.opts
        for option in options
          for v, i in option
            option[i] = (v + Array(max[i] + 1 - v.length).join ' ')
            .replace /\$(\d)/g, (str, n) ->
              m = 0
              for j in [0...n]
                m += max[j]
              Array(m+space.length*n+1).join ' '
          p option.join(space), on
    else
      p @banner if @banner
      p "#USAGE#"
      p "      #{@prefix} #{s_comd} #{s_opts} #{s_args}"
      p "  #{@default.desc}"
      unless isEmpty @cmds
        p "#COMMANDS#"
        for cmd, opt of @cmds
          continue if opt.aliasOf
          p "  #{opt.desc}:"
          p "      #{cmdHelper cmd, opt}"
    addColor lines.join '\n'
  showHelp: (cmd) ->
    console.info @help cmd

buildCmds = (cmds) ->
  ret = {}
  # Copy alias
  add = (cmd, opt, alias) ->
    helper = (opt) ->
      opt.aliasOf && " (alias of #{opt.aliasOf})" || ''
    if ret[cmd]
      errCmdConflict cmd, opt, ret[cmd]
      process.exit 1
    ret[cmd] = __proto__: opt
    ret[cmd].aliasOf = alias if alias
  for cmd, opt of cmds
    continue if cmd == '_default'
    add cmd, opt
    if opt.alias
      opt.alias = [].concat opt.alias
      add alias, opt, cmd for alias in opt.alias
  ret