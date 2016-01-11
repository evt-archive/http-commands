module HTTP
  module Commands
    def self.content_length(data)
      data.bytesize
    end
  end
end
