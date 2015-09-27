require_relative 'lib/svn.rb'

SVN.username = "a_username"
SVN.password = "a_password"
SVN.path="/home/tachyons/projects/interim-test-svn"
SVN.add("/home/tachyons/projects/interim-test-svn/svn_ruby.md")
SVN.commit("commit from ruby")
