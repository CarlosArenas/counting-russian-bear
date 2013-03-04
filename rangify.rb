require 'csv'

class BatesNumber
  attr_reader :prefix, :number, :suffix

  def initialize(bates_number)
    if md = /^(.*?\D)?(\d+)(\D.*)?$/.match(bates_number)
      @prefix = md[1]
      @number = md[2]
      @suffix = md[3]
    end
  end

  def next
    if self.suffix.nil?
      self.prefix + self.number.next
    else
      self.prefix + self.number + self.suffix.next
    end
  end

  def to_s
    prefix = self.prefix || ''
    number = self.number || ''
    suffix = self.suffix || ''
    prefix + number + suffix
  end
end

Document = Struct.new(:first_page, :last_page)
BatesRange = Struct.new(:first_page, :last_page)

# read list of documents
docs = Hash.new{|h, k| h[k] = []}
CSV.foreach(ARGV[0], headers: true) do |row|
  # parse entries
  beg_bates = row[0]
  end_bates = row[1]
  custodian = row[2]

  # deal with missing values
  end_bates = beg_bates if end_bates.nil? or end_bates.empty?
  custodian = '[na]'    if custodian.nil? or custodian.empty?

  # track row as custodian's document
  docs[custodian] << Document.new( BatesNumber.new(beg_bates), BatesNumber.new(end_bates))
end

# write custodian ranges
CSV(STDOUT, force_quotes: true ) do |csv|

  # rangify each custodian's documents
  docs.each do |custodian, documents|
    ranges = Array.new
    range  = BatesRange.new

    # start range with first doc
    first_doc = documents.shift
    range.first_page = first_doc.first_page
    range.last_page  = first_doc.last_page

    # continue rangifying remaining docs
    documents.each do |doc|
      if range.last_page.next == doc.first_page.to_s
        range.last_page = doc.last_page
      else
        ranges << range
        range = BatesRange.new
        range.first_page = doc.first_page
        range.last_page  = doc.last_page
      end
    end

    # report ranges
    ranges << range
    ranges.each { |range| csv <<  [custodian, range.first_page, range.last_page] }

  end
end
