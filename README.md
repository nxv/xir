# Xir.js

Xir is a flexible web framework which provides easy-to-use, straight-
forward, and powerful server structures to manage all your codes and
resources.

# Features

Xir implements an extendible compiler system. You can write everything
in other languages like CoffeeScript instead JavaScript, LESS instead
CSS, and Jade instead HTML. The system will compile all your source
code instantly or dynamically, and manage the cache as well.

# Installation

    npm install -g xir

# Usage

    xir [COMMAND] [OPTION]... [ARGUMENT]...

Each option can be placed before command or after argument.

## Commands

- `new|create <NAME>...`
- `run|start|up [NAME]`
- `add <PLUGIN>...`
- `remove|rm|delete <PLUGIN>...`
- `search|find <PLUGIN>...`
- `info <PLUGIN>`
- `help [COMMAND]`

### Create new instances

    xir <new|create> [OPTION]... <NAME>...

### Start an instance

    xir <run|start|up> [OPTION]... [NAME]

### Add plugins to current instance

    xir add [OPTION]... <PLUGIN>...

### Remove plugins from current instance

    xir <remove|rm|delete> [OPTION]... <PLUGIN>...

### Search plugins in local or on the Internet

    xir <search|find> [OPTION]... <PLUGIN>...

### Display the information of a plugin

    xir info [OPTION]... <PLUGIN>

### Show help and options

    xir help [OPTION]... [COMMAND]
