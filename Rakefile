require 'rake/clean'

task :default => [:all]

OUTPUT_DIR = 'public_static'
CLEAN.include OUTPUT_DIR

directory OUTPUT_DIR

task :html => ['public_static'] do
  puts 'index.html'
  system "haml index.haml #{OUTPUT_DIR}/index.html"
end

task :css => ['public_static'] do
  puts 'styles.css'
  system "sass styles.scss #{OUTPUT_DIR}/styles.css"
end

task :js => [ 'public_static'] do
  puts 'main.js'
  system "coffee -o #{OUTPUT_DIR} main.coffee"
end

task :all => [:js, :html, :css]
