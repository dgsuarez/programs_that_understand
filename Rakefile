require 'rake/clean'
source_files = Rake::FileList.new("**/*.cr", "**/*.rb")

CLEAN.include("dist/")

task default: :doc
task :doc do
  sh "docco -l linear -L docco_lang.json -o dist/ index.md"
  sh "docco -l classic -L docco_lang.json -o dist/code #{source_files}"
end
