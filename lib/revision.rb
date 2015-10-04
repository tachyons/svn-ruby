module SVN
  class Revision
    attr_accessor :author,:date,:message,:revision_no
    def self.make_from_xml_doc
      doc.css("logentry").each do |logentry|
        revision_no=logentry.attributes["revision"].content
        author= logentry.at_css("author").content
        date= logentry.at_css("date").content
        message= logentry.at_css("msg").content
      end
    end
  end
end
