module QuickSearch
  class ArxivSearcher < QuickSearch::Searcher

    def search
      url = base_url + parameters.to_query
      raw_response = @http.get(url)
      @response = Nokogiri::XML(raw_response.body)
    end

    def results
      if results_list
        results_list
      else
        @results_list = []
        @response.xpath('//xmlns:entry').each do |value|
          result = OpenStruct.new

          result.title = title(value)
          result.link = link(value)
          result.author = author(value)
          result.date = updated(value)

          @results_list << result
        end
        @results_list
      end
    end

    def total
      @response.xpath('//opensearch:totalResults', 'opensearch' => 'http://a9.com/-/spec/opensearch/1.1/')[0].content
    end

    def loaded_link
      QuickSearch::Engine::ARXIV_CONFIG['loaded_link'] + http_request_queries['uri_escaped']
    end

    private

    def base_url
      QuickSearch::Engine::ARXIV_CONFIG['base_url'] + QuickSearch::Engine::ARXIV_CONFIG['wskey'] + "&"
    end

    def parameters
      {
        'q' => http_request_queries['not_escaped']
      }
    end

    def title(value)
      value.at('title').content if value.at('title')
    end

    def link(value)
      id = value.at('id').content[25..-1] if value.at('id')
      QuickSearch::Engine::ARXIV_CONFIG['url_link'] + id
    end

    def author(value)
      authors = []
      value.search('author/name').children.each do |a|
        authors << a.content
      end
      authors.join(', ')
    end

    def updated(value)
      datetime = value.at('updated').content if value.at('updated')
      d = Time.zone.parse(datetime)
      d.strftime('%Y')
    end

  end
end
