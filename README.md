# QuickSearch arXiv Searcher

## Description

A QuickSearch searcher for ArXiv (https://arxiv.org/)

## Installation

Include the searcher gem  in your Gemfile:

    gem 'quick_search-arxiv_searcher'

Include as a searcher in your config/quick_search_config.yml:

    searchers = [arxiv, ..., some_searcher]

Run bundle install:

    bundle install

Include in your Search Results page

     <%= render_module @arxiv, 'arxiv' %>

For more general information about setting up searcher plugins in QuickSearch, see https://github.com/NCSU-Libraries/quick_search
