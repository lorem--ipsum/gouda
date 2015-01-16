gulp        = require 'gulp'
gutil        = require 'gutil'
coffee      = require 'gulp-coffee'
mocha       = require 'gulp-mocha'
runSequence = require 'run-sequence'


gulp.task 'src:compile', ->
  return gulp.src('./src/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./build/'))


gulp.task 'test:compile', ->
  return gulp.src('./test/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./test/'))

gulp.task 'test:run', ['test:compile'], ->
  return gulp.src('test/*.js', {read: false})
          .pipe(mocha({reporter: 'dot'})); # nyan, spec, min

gulp.task 'watch', ->
  gulp.watch ['src/*.coffee'], ->
    runSequence(
      ['src:compile']
      ['test:compile', 'test:run']
    )
  gulp.watch ['test/*.coffee'], ['test:compile', 'test:run']

gulp.task 'default', ->
  runSequence(
    ['src:compile']
    ['test:compile', 'test:run']
  )
