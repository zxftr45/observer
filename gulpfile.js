var gulp            = require('gulp'),
    concat          = require('gulp-concat'),
    uglify          = require('gulp-uglify'),
    rev             = require('gulp-rev'),
    sass            = require('gulp-sass'),
    autoprefixer    = require('gulp-autoprefixer'),
    minifycss       = require('gulp-minify-css'),
    clean           = require('gulp-clean');

var paths = {
  js: ['frontend/js/*'],
  css: [
    'frontend/scss/main.scss',
    'bower_components/skeleton/css/normalize.css',
    'bower_components/skeleton/css/skeleton.css'
  ]
}

gulp.task('clean', function() {
  return gulp.src('public/assets/*', { read: false })
    .pipe(clean())
});

gulp.task('scripts', function() {
  return gulp.src(paths.js)
    .pipe(concat('application.js'))
    .pipe(uglify())
    .pipe(gulp.dest('public/assets'))
});

gulp.task('styles', function() {
  return gulp.src(paths.css)
    .pipe(concat('main.scss'))
    .pipe(sass({errLogToConsole: true }))
    .pipe(autoprefixer())
    .pipe(concat('application.css'))
    .pipe(minifycss())
    .pipe(gulp.dest('public/assets'))
});

gulp.task('revision', function() {
  return gulp.src(['public/assets/*.css', 'public/assets/*.js'])
    .pipe(rev())
    .pipe(gulp.dest('public/assets'))
    .pipe(rev.manifest({ path: 'manifest.json' }))
    .pipe(gulp.dest('public/assets'));
});

gulp.task('dev', ['clean', 'scripts', 'styles'], function() {
  gulp.start('revision');
});

gulp.task('watch', function() {
  gulp.watch(paths.js, ['dev']);
  gulp.watch(paths.css, ['dev']);
});

gulp.task('default', ['clean', 'dev', 'watch']);