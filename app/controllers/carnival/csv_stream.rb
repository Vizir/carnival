module Carnival
  module CsvStream
    def self.included(base)
      base.class_eval do
        include ActionController::Live
      end
    end

    def stream_csv(relation, lines_per_chunk, presenter)
      begin
        response.stream.write presenter.csv_for_header
        relation.find_each(batch_size: lines_per_chunk) do |record|
          response.stream.write presenter.csv_for_record(record)
        end
      ensure
        response.stream.close
      end
    end
  end
end
