header = """
  /**
   * Xir.js
   * https://github.com/rixtox/xir
   *
   * Copyright 2014, Naiwei Zheng
   * Released under the MIT License
   */\n\n
"""

module.exports = (grunt) ->

  grunt.initConfig
    clean:
      js:
        src: 'lib/**/*.js'
    coffee:
      options:
        bare: on
      compile:
        files: [
          expand: on
          cwd: 'src/'
          src: '**/*.coffee'
          dest: 'lib/'
          ext: '.js'
        ]
    concat:
      banner:
        options:
          banner: header
        files: [
          expand: on
          cwd: 'lib/'
          src: '**/*.js'
          dest: 'lib/'
        ]

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  grunt.registerTask 'build', ['coffee', 'concat']
  grunt.registerTask 'default', ['build']
