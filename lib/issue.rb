require 'rubygems'
require 'active_resource'
require_relative 'revision'

module PMS
  class Issue < ActiveResource::Base
    self.site = 'http://pms.foradian.org/'
    self.user = 'api-key'
    self.password = 'random'
    def related_revisions
      SVN::Revision.search(self.id)
    end
  end
end
# # Retrieving issues
# issues = Issue.find(:all)
# puts issues.first.subject
#
# # Retrieving an issue
# issue = Issue.find(1)
# puts issue.description
# puts issue.author.name
#
# # Creating an issue
# issue = Issue.new(
#   :subject => 'REST API',
#   :assigned_to_id => 1,
#   :project_id => 1
# )
# issue.custom_field_values = {'2' => 'Fixed'}
# if issue.save
#   puts issue.id
# else
#   puts issue.errors.full_messages
# end
#
# # Updating an issue
# issue = Issue.find(1)
# issue.subject = 'REST API'
# issue.save
#
# # Deleting an issue
# issue = Issue.find(1)
# issue.destroy
