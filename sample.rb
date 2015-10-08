require_relative 'lib/svn.rb'
require_relative 'lib/issue.rb'
require 'yaml'
config = YAML::load_file(File.join(__dir__, 'config.yml'))
SVN.path= config["svn"]["path"]
SVN.verified_path= config["svn"]["verified_path"]
SVN.username= config["svn"]["username"]
SVN.password= config["svn"]["password"]
puts "Enter Bug number"
bug_number=gets.chomp
issue=PMS::Issue.find(bug_number)
related_revisions=issue.related_revisions
related_revisions.each do |revision|
  puts "\n Revision #{revision.revision_no}"
  puts "\n Author= #{revision.author}"
end
puts "committing to verified"
related_revisions.each do |revision|
  revision.to_verified
end
