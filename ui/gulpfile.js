var gulp        = require('gulp');
    watch       = require('gulp-watch');
    browserSync = require('browser-sync').create();
    concat      = require('gulp-concat');
    clean       = require('gulp-clean');
    rev         = require('gulp-rev');
    inject      = require('gulp-inject');

gulp.task('scripts', ['clean'], function() {
  return gulp.src('src/**/*.js')
    .pipe(concat('main.js'))
    .pipe(rev())
    .pipe(gulp.dest('dist'));
});

gulp.task('styles', ['clean'], function() {
  return gulp.src('assets/**/*.css')
    .pipe(concat('main.css'))
    .pipe(rev())
    .pipe(gulp.dest('dist'));
});

gulp.task('clean', function () {
  return gulp.src('dist/*.*', {read: false})
    .pipe(clean());
});

gulp.task('inject', ['clean', 'styles', 'scripts'], function () {
  var target = gulp.src('src/index.html');
  var sources = gulp.src(['dist/*.js', 'dist/*.css'], {read: false});

  return target.pipe(inject(sources))
    .pipe(gulp.dest('.'));
});

gulp.task('compile', ['clean', 'scripts', 'styles', 'inject'])

gulp.task('bs-reload', ['compile'], function () {
  browserSync.reload();
});

gulp.task('watch', ['compile', 'bs-reload'], function() {
  browserSync.init({
    server: ".",
    port: 8080,
    ui: false,
    notify: false
  });

  gulp.watch('src/**/*.*', ['compile', 'bs-reload']);
  gulp.watch('assets/*.*', ['compile', 'bs-reload']);
});

gulp.task('default', ['watch']);
