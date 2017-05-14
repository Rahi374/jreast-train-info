# coding: utf-8
require "nokogiri"
require "open-uri"
require "sinatra"
require "sinatra/json"
require "sinatra/cross_origin"

# Settings
server_name = "amanokami"
github = "https://github.com/Rahi374/jreast-train-info"

# Need to enable CORS (obviously)
configure do
  enable :cross_origin
end

# These are just notes

# doc = Nokogiri::HTML(open("http://traininfo.jreast.co.jp/train_info/kanto.aspx"))

# doc.xpath("//tr")[0].children[1].text  # 東海道線
# doc.xpath("//tr")[0].children[3].children[0].attr("alt")  # 平常運転

# doc.xpath("//tr")[1].children[1].text  # 京浜東北線
# doc.xpath("//tr")[1].children[3].children[0].attr("alt")  # 遅延
# doc.xpath("//tr")[2].children[1].text  # 京浜東北線は、大井町駅での安全確認に伴う乗務員手配の影響で、上下線に遅れがでています。
# doc.xpath("//tr")[2].children[3].children[0].attr("alt")  # NoMethodError: undefined method `children' for nil:NilClass

# doc.xpath("//tr")[3].children[1].text  # 横須賀線
# doc.xpath("//tr")[3].children[3].children[0].attr("alt")  # 平常運転


# The trains appear in this order, but I don't use these numbers
# since for some reason JR adds another element to this array to
# display the reason why the train of the previous element is late

# 0 東海道線
# 1 京浜東北線
# 2 横須賀線
# 3 南武線
# 4 横浜線
# 5 伊東線
# 6 相模線
# 7 鶴見線
# 8 宇都宮線
# 9 高崎線
# 10 京浜東北線
# 11 埼京線
# 12 川越線
# 13 武蔵野線
# 14 上越線
# 15 信越本線
# 16 吾妻線
# 17 烏山線
# 18 八高線
# 19 日光線
# 20 両毛線
# 21 中央線快速電車
# 22 中央・総武各駅停車
# 23 中央本線
# 24 武蔵野線
# 25 五日市線
# 26 青梅線
# 27 八高線
# 28 小海線
# 29 常磐線
# 30 常磐線快速電車
# 31 常磐線各駅停車
# 32 水郡線
# 33 水戸線
# 34 総武快速線
# 35 総武本線
# 36 中央・総武各駅停車
# 37 京葉線
# 38 武蔵野線
# 39 内房線
# 40 鹿島線
# 41 久留里線
# 42 外房線
# 43 東金線
# 44 成田線
# 45 山手線
# 46 上野東京ライン
# 47 湘南新宿ライン

# This hash is to translate English train names into
# the Japanese names/strings
# So far I have restricted the romaji to these, but I
# may relax them in the future
# TODO Relax romaji restrictions
# TODO Add Japanese versions without sen
# TODO Relax Japanese restrictions (eg. chuo_local)
train_hash = {
  "tokaido" => "東海道線",
  "keihintohoku" => "京浜東北線",
  "yokosuka" => "横須賀線",
  "nanbu" => "南武線",
  "yokohama" => "横浜線",
  "ito" => "伊東線",
  "sagami" => "相模線",
  "tsurumi" => "鶴見線",
  "utsunomiya" => "宇都宮線",
  "takasaki" => "高崎線",
  "saikyo" => "埼京線",
  "kawagoe" => "川越線",
  "musashino" => "武蔵野線",
  "joetsu" => "上越線",
  "shinetsu" => "信越本線",
  "agatsuma" => "吾妻線",
  "karasuyama" => "烏山線",
  "hachiko" => "八高線",
  "nikko" => "日光線",
  "ryomo" => "両毛線",
  "chuo_rapid" => "中央線快速電車",
  "chuo_sobu_local" => "中央・総武各駅停車",
  "chuo" => "中央本線",
  "itsukaichi" => "五日市線",
  "ome" => "青梅線",
  "koumi" => "小海線",
  "joban" => "常磐線",
  "joban_rapid" => "常磐線快速電車",
  "joban_local" => "常磐線各駅停車",
  "suigun" => "水郡線",
  "mito" => "水戸線",
  "sobu_rapid" => "総武快速線",
  "sobu" => "総武本線",
  "keiyo" => "京葉線",
  "uchibo" => "内房線",
  "kashima" => "鹿島線",
  "kururi" => "久留里線",
  "sotobo" => "外房線",
  "togane" => "東金線",
  "narita" => "成田線",
  "yamanote" => "山手線",
  "ueno_tokyo" => "上野東京ライン",
  "shonan_shinjuku" => "湘南新宿ライン"
}
rev_train_hash = {}
train_hash.map{|k, v| rev_train_hash[v] = k}

# This hash is not used yet, but will be used later
# for when I add proper English support
train_hash_translate = {
  "東海道線" => "Tokaido Line",
  "京浜東北線" => "Keihintohoku Line",
  "横須賀線" => "Yokosuka Line",
  "南武線" => "Nanbu Line",
  "横浜線" => "Yokohama Line",
  "伊東線" => "Ito Line",
  "相模線" => "Sagami Line",
  "鶴見線" => "Tsurumi Line",
  "宇都宮線" => "Utsunomiya Line",
  "高崎線" => "Takasaki Line",
  "埼京線" => "Saikyo Line",
  "川越線" => "Kawagoe Line",
  "武蔵野線" => "Musashino Line",
  "上越線" => "Joetsu Line",
  "信越本線" => "Shinetsu Main Line",
  "吾妻線" => "Agatsuma Line",
  "烏山線" => "Karasuyama Line",
  "八高線" => "Hachiko Line",
  "日光線" => "Nikko Line",
  "両毛線" => "Ryomo Line",
  "中央線快速電車" => "Chuo Line Rapid",
  "中央・総武各駅停車" => "Chuo/Sobu Line Local",
  "中央本線" => "Chuo Main Line",
  "五日市線" => "Itsukaichi Line",
  "青梅線" => "Ome Line",
  "小海線" => "Koumi Line",
  "常磐線" => "Joban Line",
  "常磐線快速電車" => "Joban Line Rapid",
  "常磐線各駅停車" => "Joban Line Local",
  "水郡線" => "Suigun Line",
  "水戸線" => "Mito Line",
  "総武快速線" => "Sobu Line Rapid",
  "総武本線" => "Sobu Main Line",
  "京葉線" => "Keiyo Line",
  "内房線" => "Uchibo Line",
  "鹿島線" => "Kashima Line",
  "久留里線" => "Kururi Line",
  "外房線" => "Sotobo Line",
  "東金線" => "Togane Line",
  "成田線" => "Narita Line",
  "山手線" => "Yamanote Line",
  "上野東京ライン" => "Ueno-Tokyo Line",
  "湘南新宿ライン" => "Shonan-Shinjuku Line"
}

# Input Japanese time string
# Output iso8601 time string
def transform_time t
  year  = t.match(/[0-9]{4}年/)[0][0..-2].to_i
  month = t.match(/[0-9]{1,2}月/)[0][0..-2].to_i
  day   = t.match(/[0-9]{1,2}日/)[0][0..-2].to_i
  hour  = t.match(/[0-9]{1,2}時/)[0][0..-2].to_i
  min   = t.match(/[0-9]{1,2}分/)[0][0..-2].to_i
  tz    = "+9"
  DateTime.iso8601(DateTime.new(year, month, day, hour, min, 0, tz).to_s)
end

# The main method. Retrives the status of a train
get "/:train" do
  # A reminder on how Sinatra params work
  # params["train"]

  # Fetch the HTML page of the train statuses
  doc = Nokogiri::HTML(open("http://traininfo.jreast.co.jp/train_info/kanto.aspx"))

  # "Header" of the JSON that will be returned.
  # Server name and github taken from the settings at the beginning
  info = {
    server_name: server_name,
    source: "http://traininfo.jreast.co.jp/train_info/kanto.aspx",
    github: github,
  }
  
  # Main part
  # Goes down the HTML table looking for the index number of the train
  # that was requested.
  # If it doesn't exist, send an error message/JSON and finish
  # If it does exist, save the index number of the train as i
  i = 0
  while true
    node = doc.xpath("//tr")[i]
    if node.nil? then return json response: { info: info, error: "That train does not exist." } end
    if params["train"] == node.children[1].text or train_hash[params["train"]] == node.children[1].text then break end
    i += 1
  end

  # Fetch the "updated at" time
  # DONE Change this to a time-type value, not just a (Japanese) string
  t = doc.xpath("//h2").children[2].text[7..-1]
  updated_at = transform_time t

  # Build the train_data hash from the name and status of the train
  # (fetched from the HTML doc)
  # TODO Language (English) support
  train_data = {
    train_name: doc.xpath("//tr")[i].children[1].text,
    train_status: doc.xpath("//tr")[i].children[3].children[0].attr("alt")
  }

  # If the train status is anything other than "normal",
  # build the train_late_data hash from the reason the train was late
  # and the time the train-late status/reason was updated (both from the HTML doc)
  # TODO Language (English) support
  if train_data[:train_status] != "平常運転"
    train_late_data = {
      train_reason: doc.xpath("//tr")[i+1].children[1].text,
      train_late_updated_at: transform_time(doc.xpath("//tr")[i].children[5].text[0..-4])
    }
  end

  # Build the JSON from:
  # - the JSON "header"
  # - the updated_at variable
  # - the train data hash
  # - the train late data hash
  return json response: {
                info: info,
                data: {
                  updated_at: updated_at,
                  train_data: train_data,
                  train_late_data: train_late_data
                }
              }
  
end


get "/" do
  return json response: {
                info: "Use /:train_name, where :train_name is one from the train_list",
                train_list: rev_train_hash,
                error: "No train specified"}
end



# Misc TODOs:
# - Return train statuses of all related lines (Chuo, Joban)
#   (eg. If requested for Chuo line, return statuses of Chuo Main line, Chuo Rapid, and Chuo local)
# - DONE - Maybe add a Gemfile?
