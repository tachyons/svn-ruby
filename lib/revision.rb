module SVN
  class Revision
    attr_accessor :author,:date,:message,:revision_no
    def self.make_from_xml_doc(doc)
      revisions=[]
      doc.css("logentry").each do |logentry|
        revision=SVN::Revision.new
        revision.revision_no=logentry.attributes["revision"].content
        revision.author= logentry.at_css("author").content
        revision.date= logentry.at_css("date").content
        revision.message= logentry.at_css("msg").content
        revisions <<revision
      end
      return revisions
    end
    def self.find_by_revision_number(revision_no)
      xml=SVN.get_log(revision_no)
      doc = Nokogiri::XML(xml)
      SVN::Revision.make_from_xml_doc(doc).first
    end
  end
end
