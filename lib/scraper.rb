require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    url = "./fixtures/student-site/index.html"
    page = open(url)
    doc = Nokogiri::HTML(page)
    student_card = doc.css(".student-card").map do |student_card|
    name = student_card.css("h4.student-name").text
    location = student_card.css("p.student-location").text
    profile_url = student_card.css("a").attr("href").value
    {
      :name => name,
      :location => location,
      :profile_url => profile_url
    }
  end
end

  def self.scrape_profile_page(profile_url)
    url = profile_url
    page = open(url)
    doc = Nokogiri::HTML(page)
    student = {}
    links = doc.css("div.social-icon-container a").map  do |a|
      a.attr("href")
    end
    links.each do |link|
      if link.include?("twitter")
        student[:twitter] = link
      elsif link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      else
        student[:blog] = link
      end
    student[:bio] = doc.css("div.description-holder p").text
    student[:profile_quote] = doc.css("div.vitals-text-container div.profile-quote").text
  end
  student
end

end
