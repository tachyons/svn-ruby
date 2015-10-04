require_relative 'lib/svn.rb'

# SVN.username = "a_username"
# SVN.password = "a_password"
# SVN.path="/home/tachyons/projects/interim-test-svn"
# SVN.add("/home/tachyons/projects/interim-test-svn/svn_ruby.md")
# SVN.commit("commit from ruby")
f = File.open("sample.xml")
doc = Nokogiri::XML(f)
f.close
doc.css("logentry").each do |logentry|
  revision=logentry.attributes["revision"].content
  author= logentry.at_css("author").content
  date= logentry.at_css("date").content
  msg= logentry.at_css("msg").content
end
