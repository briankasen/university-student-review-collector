require 'HTTParty'
require 'Nokogiri'
require 'csv'
require 'byebug'

pages_array = ['https://www.unigo.com/colleges/northwestern-university/',
  'https://www.unigo.com/colleges/university-of-michigan-ann-arbor/',
  'https://www.unigo.com/colleges/university-of-wisconsin-madison/',
  'https://www.unigo.com/colleges/university-of-illinois-at-urbana-champaign/',
  'https://www.unigo.com/colleges/purdue-university-main-campus/',
  'https://www.unigo.com/colleges/pennsylvania-state-university-main-campus/',
  'https://www.unigo.com/colleges/ohio-state-university-main-campus/',
  'https://www.unigo.com/colleges/university-of-minnesota-twin-cities/',
  'https://www.unigo.com/colleges/michigan-state-university/',
  'https://www.unigo.com/colleges/university-of-maryland-college-park/',
  'https://www.unigo.com/colleges/indiana-university-bloomington/',
  'https://www.unigo.com/colleges/university-of-iowa/',
  'https://www.unigo.com/colleges/rutgers-university-new-brunswick/',
  'https://www.unigo.com/colleges/university-of-nebraska-lincoln/'
]

reviews_per_page = 10 # value should remain 10 unless unigo changes their recent reviews section's # of displayed reviews
reviews_per_school = 50# must be a value greater than 5

reviews_array = Array[]

institution_number = 0

while institution_number < pages_array.size

  page_number = 1
  while page_number <= (reviews_per_school / reviews_per_page.to_f).round
    puts pages_array[institution_number] + page_number.to_s
    page_review_number = 0
    while page_review_number < reviews_per_page
      page = HTTParty.get(pages_array[institution_number] + page_number.to_s)

      parse_page = Nokogiri::HTML(page)

      review_count = parse_page.css('.minicard').size
      review_id = parse_page.css('.minicard')[page_review_number].css('.profile-user__review-card').children[3].text.strip
      reviewer_name = parse_page.css('.minicard')[page_review_number].css('.profile-user__review-card--name').children.first.text.strip

      if parse_page.css('.minicard')[page_review_number].css('.starRating').css('.starCount').size > 0
        star_rating = parse_page.css('.minicard')[page_review_number].css('.starRating').css('.starCount').first.attributes["style"].value.gsub('width: ', '').to_i / 20
      else
        # stars were not provided by reviewer, so we set the value to -1 to denote a non-response
        star_rating = -1
      end
      review = parse_page.css('.minicard')[page_review_number].css('.show-on-open').first.at('p').children[0].text.strip
      url = page.request.last_uri.to_s

      review = {'review_id' => review_id, 'review_name' => reviewer_name, 'star_rating' => star_rating, 'review' => review, 'url' => url}

      reviews_array.push(review)
      page_review_number += 1
    end

    page_number += 1
  end
  institution_number += 1
end

# output the array of reviews to flat files
current_review = 0

# output the entire review to our collection of all reviews and their details
column_names = reviews_array.first.keys

csv_data =  CSV.generate do |csv|
  while current_review < reviews_array.size
    if current_review == 0
      csv << column_names
    end
    csv << reviews_array[current_review].values
    # reviews_array[current_review].to_a.each {|elem| csv << elem}
    # csv << reviews_array[current_review]
    current_review +=1
  end
end
File.write('_reviews_collection.csv', csv_data)

# output each review to its own unique txt file
current_review = 0

while current_review < reviews_array.size
  review_id = reviews_array[current_review]["review_id"]
  review_text = reviews_array[current_review]["review"]
  csv_data =  CSV.generate do |csv|
    csv << [review_text]
  end
  file_name = 'review_'+ review_id.to_s + '.txt'
  File.write(file_name, csv_data)
  current_review +=1
end
