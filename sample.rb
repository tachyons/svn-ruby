require_relative 'lib/svn.rb'
require 'yaml'
# SVN.username = "a_username"
# SVN.password = "a_password"
config = YAML::load_file(File.join(__dir__, 'config.yml'))
SVN.path= config["svn"]["path"]
SVN.verified_path= config["svn"]["verified_path"]
SVN.username= config["svn"]["username"]
SVN.password= config["svn"]["password"]
# SVN.add("/home/tachyons/projects/interim-test-svn/svn_ruby.md")
# SVN.commit("commit from ruby")
config = YAML::load_file(File.join(__dir__, 'config.yml'))
f = File.open("sample.xml")
doc = Nokogiri::XML(f)
f.close
revisions=SVN::Revision.make_from_xml_doc(doc)
