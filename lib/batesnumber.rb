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