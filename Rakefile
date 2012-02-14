require 'rake/clean'

task :default => [:all]

OUTPUT_DIR = 'public_static'
CLEAN.include OUTPUT_DIR

directory OUTPUT_DIR

task :html => [OUTPUT_DIR] do
  puts 'index.html'
  system "haml index.haml #{OUTPUT_DIR}/index.html"
end

task :css => [OUTPUT_DIR] do
  puts 'styles.css'
  system "sass styles.scss #{OUTPUT_DIR}/styles.css"
end

task :js => [ OUTPUT_DIR ] do
  puts 'main.js'
  cp Dir.glob("*.js"), OUTPUT_DIR
  Dir.glob("*.coffee").each do |file|
    system "coffee -o #{OUTPUT_DIR} #{file}"
  end
end

task :watch do
  system "sass --watch styles.scss:#{OUTPUT_DIR}/styles.css"
end

desc "Create all static assets for this project"
task :all => [:js, :html, :css]
