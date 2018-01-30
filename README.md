# Big Ten University Student Review Collector

- Web Scraping
- Ruby
- Text Mining

Purpose: For a data science text mining group project, We needed to collect a number of reviews from a set of companies within any particular industry. The selected industry was higher education since our group had an intrinsic interest in the higher education space for a number of years and our coursework was a part of the MBA program at the University of Nebraska - Lincoln, Big Ten University.

The analysis consisted of collected n reviews for each Big Ten University. We decided to build a web scraping script to expedite the review collection process. All reviews were collected from the website www.unigo.com (http://www.unigo.com).

Once the reviews were collected, the text mining will be done in R due to the constraints of the grad school project guidelines. The user can specify the number of reviews to collect from each school. The reviews were collected and saved to an aggregate file for later reference. Each individual review was saved to a txt file so that we could then create a text corpus to mine.

 A link to the R text mining project will be posted here and shared in my github repo eventually. More soon....

## Getting Started

The script relies on the following ruby gems:

```ruby
gem 'HTTParty'
gem 'Nokogiri'
gem 'csv'
```
Next run the script in your console to generate the collection csv and txt files for each review:

```console
$ ruby _web_scraper.rb
```
