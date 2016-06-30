# coding: utf-8
require "nokogiri"
require "open-uri"
require "sinatra"

doc = Nokogiri::HTML(open("http://traininfo.jreast.co.jp/train_info/kanto.aspx"))

doc.xpath("//tr")[0].children[1].text  # 東海道線
doc.xpath("//tr")[0].children[3].children[0].attr("alt")  # 平常運転

doc.xpath("//tr")[1].children[1].text  # 京浜東北線
doc.xpath("//tr")[1].children[3].children[0].attr("alt")  # 遅延
doc.xpath("//tr")[2].children[1].text  # 京浜東北線は、大井町駅での安全確認に伴う乗務員手配の影響で、上下線に遅れがでています。
doc.xpath("//tr")[2].children[3].children[0].attr("alt")  # NoMethodError: undefined method `children' for nil:NilClass

doc.xpath("//tr")[3].children[1].text  # 横須賀線
doc.xpath("//tr")[3].children[3].children[0].attr("alt")  # 平常運転

