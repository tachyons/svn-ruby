require 'rubygems'
require 'nokogiri'
require 'net/http'
require 'uri'
# require_relative 'revision'


module SVN

  class << self
    attr_accessor :username, :password,:path,:verified_path
  end

  # Returns a string to be passed into commands containing authentication options
  # Requires setting of username and password via attr_accessor methods
  def self.authentication_details
    if @username.to_s.empty? || password.to_s.empty?
      ""
    else
      "--username #{@username} --password #{@password}"
    end
  end

  # Returns an array representing the current status of any new or modified files
  def self.status
    SVN.execute("status").split(/\n/).map do |file|
      file =~ /(\?|\!|\~|\*|\+|A|C|D|I|M|S|X)\s*([\w\W]*)/
      [$1, $2]
    end
  end

  # Adds the given path to the working copy
  def self.add(path)
    SVN.execute("add #{path}")
  end

  # Adds all new or modified files to the working copy
  def self.add_all
    SVN.status.each { |file| add = SVN.add(file[1]) if file[0] == '?' }
  end

  # Add all new or modified files to the working copy and commits changes
  # An optional commit message can be passed if required
  def self.add_and_commit_all(message=nil)
    SVN.add_all
    SVN.commit message
  end

  # Commits all changes, and returns the new revision number
  # An optional commit message can be passed if required
  def self.commit(message=nil)
    if message.nil?
      action = SVN.execute("commit")
    else
      action = SVN.execute("commit -m '#{message}'")
    end
    if action.split(/\n/).last =~ /Committed revision (\d+)\./
      return $1
    else
      return nil
    end
  end

  # Returns a diff of two commits based on their respective revision numbers
  # (first and second arguments) and a repository path (third argument)
  def self.diff(revision_1,revision_2,file=nil)
    if file.nil?
      SVN.execute("diff -r #{revision_1}:#{revision_2}")
    else
      SVN.execute("diff -r #{revision_1}:#{revision_2} #{file}")
    end
  end

  # Retrieve a file based on it's path and commit revision number
  def self.get(file,revision)
    SVN.execute("cat -r #{revision} #{file}")
  end

  # Rename a file based on the given current and new filenames
  def self.rename(old_filename, new_filename)
    SVN.execute("rename #{old_filename} #{new_filename}")
  end

  # Delete a file based on a given path
  def self.delete(file)
    SVN.execute("delete #{file}")
  end
  # Get log
  def self.logs
    SVN.execute("log")
  end
  # get a log of a particualr revision
  def self.get_log(revision_no)
      SVN.execute("log -r #{revision_no} --xml")
  end
  #search string
  def self.search(search_term)
    SVN.execute("log --search #{search_term} --xml")
  end

  #copy the repo
  def self.copy(source,destination,message="")
    puts "svn copy #{source} #{destination} -m '#{message}''"
    `svn copy #{source} #{destination} -m '#{message}'`
  end
  def self.information
    SVN.execute("info --xml")
  end
  def self.url
    xml=self.information
    doc = Nokogiri::XML(xml)
    url=doc.css("url").first.content
    return url
  end
  def self.root_url
    xml=self.information
    doc = Nokogiri::XML(xml)
    url=doc.css("root").first.content
    return url
  end
  def self.branches_path(branch_name)
    self.root_url+"/branches/"+branch_name
  end
  def self.tags_path(tag_name)
    self.root_url+"/tags/"+tag_name
  end
  def self.trunk_path
    self.root_url+"/trunk"
  end
  def self.make_branch(branch_name)
    self.copy(trunk_path,branches_path(branch_name),"created the branch #{branch_name}")
  end
  def self.make_tag(tag_name)
    self.copy(trunk_path,tags_path(tag_name),"created the tag #{tag_name}")
  end
  def self.merge_revision_from_path(revision_no,path)
    self.update
    self.update("verified")
    SVN.execute("merge -c #{revision_no} #{path}","verified")
    # TODO commit
    # SVN.execute("merge -c #{revision_no} #{path} --dry-run")
  end
  def self.merge_revision_from_verified(revision_no)
    self.merge_revision_from_path(revision_no,trunk_path)
  end
  def self.update(source="trunk")
    SVN.execute(" up ",source)
  end
  def self.tags
    []
  end
  def self.branches
    xml=SVN.execute("info --xml --depth=immediates ^/tags^C")
    []
  end
  private

  def self.execute(command,source="trunk")
    if @path.nil?
      puts "svn #{command} #{SVN.authentication_details}"
      return %x{svn #{command} #{SVN.authentication_details}}
    elsif source =="trunk"
      puts "svn #{command} #{SVN.authentication_details} #{@path}"
      return %x{svn #{command} #{SVN.authentication_details} #{@path}}
    elsif source=="verified"and !@verified_path.nil?
      puts "svn #{command} #{SVN.authentication_details} #{@verified_path}"
      return %x{svn #{command} #{SVN.authentication_details} #{@verified_path}}
    end
  end

end
