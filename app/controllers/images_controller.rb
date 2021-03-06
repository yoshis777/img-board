class ImagesController < ApplicationController
  require 'net/http'
  require 'json'

  def ocr_analysis
    uri = URI('https://westcentralus.api.cognitive.microsoft.com/vision/v2.0/ocr')
    uri.query = URI.encode_www_form({
                  # Request parameters
                  'language' => 'ja',
                  'detectOrientation' => 'true'
              })

    request = Net::HTTP::Post.new(uri.request_uri)
    request['Ocp-Apim-Subscription-Key'] = 'a0254da9ecc441d49a429bf045d6017b'
    request['Content-Type'] = 'application/json'
    request.body = "{\"url\": \"http://morinomanga.xyz/wp-content/uploads/2014/07/dank-01.png\"}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    puts response.body.force_encoding("utf-8")
    json_str = JSON.pretty_generate(JSON.parse(response.body))
    @result = json_str

    render 'show'
  end

end

# apim-request-id: 72c1f1c2-ccaa-4a85-bd8e-b30f5e328cb7
# Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
# x-content-type-options: nosniff
# Connection: close
# Date: Wed, 21 Nov 2018 13:17:29 GMT
# Content-Length: 12731
# Content-Type: application/json; charset=utf-8
#
# {
#     "language": "ja",
#     "textAngle": 0.0,
#     "orientation": "Up",
#     "regions": [{
#         "boundingBox": "19,14,901,1050",
#     "lines": [{
#         "boundingBox": "783,14,22,144",
#     "words": [{
#         "boundingBox": "784,14,19,24",
#     "text": "も"
# }, {
#     "boundingBox": "785,41,18,22",
#     "text": "ら"
# }, {
#     "boundingBox": "783,67,21,22",
#     "text": "え"
# }, {
#     "boundingBox": "783,93,21,23",
#     "text": "な"
# }, {
#     "boundingBox": "784,121,21,19",
#     "text": "い"
# }, {
#     "boundingBox": "791,146,4,12",
#     "text": ":"
# }]
# }, {
#     "boundingBox": "834,14,24,205",
#     "words": [{
#         "boundingBox": "834,14,24,24",
#     "text": "科"
# }, {
#     "boundingBox": "834,40,24,24",
#     "text": "学"
# }, {
#     "boundingBox": "834,68,23,22",
#     "text": "用"
# }, {
#     "boundingBox": "834,93,24,24",
#     "text": "語"
# }, {
#     "boundingBox": "835,118,23,23",
#     "text": "が"
# }, {
#     "boundingBox": "836,145,21,24",
#     "text": "多"
# }, {
#     "boundingBox": "839,171,12,23",
#     "text": "く"
# }, {
#     "boundingBox": "835,200,21,19",
#     "text": "て"
# }]
# }, {
#     "boundingBox": "861,14,24,242",
#     "words": [{
#         "boundingBox": "861,14,24,24",
#     "text": "説"
# }, {
#     "boundingBox": "862,42,21,22",
#     "text": "明"
# }, {
#     "boundingBox": "866,68,17,21",
#     "text": "し"
# }, {
#     "boundingBox": "862,93,21,22",
#     "text": "た"
# }, {
#     "boundingBox": "863,121,21,19",
#     "text": "い"
# }, {
#     "boundingBox": "861,146,23,21",
#     "text": "ん"
# }, {
#     "boundingBox": "862,171,22,22",
#     "text": "だ"
# }, {
#     "boundingBox": "863,198,21,22",
#     "text": "け"
# }, {
#     "boundingBox": "864,223,20,23",
#     "text": "ど"
# }, {
#     "boundingBox": "878,249,7,7",
#     "text": "、"
# }]
# }, {
#     "boundingBox": "887,14,24,233",
#     "words": [{
#         "boundingBox": "888,14,23,24",
#     "text": "製"
# }, {
#     "boundingBox": "889,41,21,23",
#     "text": "品"
# }, {
#     "boundingBox": "888,69,22,20",
#     "text": "の"
# }, {
#     "boundingBox": "887,92,24,24",
#     "text": "素"
# }, {
#     "boundingBox": "888,118,23,24",
#     "text": "晴"
# }, {
#     "boundingBox": "891,145,18,23",
#     "text": "ら"
# }, {
#     "boundingBox": "893,172,16,21",
#     "text": "し"
# }, {
#     "boundingBox": "891,197,17,23",
#     "text": "さ"
# }, {
#     "boundingBox": "890,223,20,24",
#     "text": "を"
# }]
# }, {
#     "boundingBox": "808,15,24,100",
#     "words": [{
#         "boundingBox": "808,15,24,22",
#     "text": "理"
# }, {
#     "boundingBox": "808,40,24,24",
#     "text": "解"
# }, {
#     "boundingBox": "813,68,17,21",
#     "text": "し"
# }, {
#     "boundingBox": "809,95,21,20",
#     "text": "て"
# }]
# }, {
#     "boundingBox": "23,27,29,98",
#     "words": [{
#         "boundingBox": "23,27,28,31",
#     "text": "な"
# }, {
#     "boundingBox": "24,65,28,26",
#     "text": "い"
# }, {
#     "boundingBox": "26,101,21,24",
#     "text": "?"
# }]
# }, {
#     "boundingBox": "128,28,31,216",
#     "words": [{
#         "boundingBox": "129,28,28,31",
#     "text": "そ"
# }, {
#     "boundingBox": "128,63,31,28",
#     "text": "ん"
# }, {
#     "boundingBox": "130,97,28,30",
#     "text": "な"
# }, {
#     "boundingBox": "132,132,22,29",
#     "text": "と"
# }, {
#     "boundingBox": "131,166,26,31",
#     "text": "き"
# }, {
#     "boundingBox": "130,202,29,29",
#     "text": "は"
# }, {
#     "boundingBox": "150,236,9,8",
#     "text": "、"
# }]
# }, {
#     "boundingBox": "57,31,32,163",
#     "words": [{
#         "boundingBox": "59,31,13,25",
#     "text": "し"
# }, {
#     "boundingBox": "59,65,29,26",
#     "text": "い"
# }, {
#     "boundingBox": "57,98,30,28",
#     "text": "ん"
# }, {
#     "boundingBox": "64,132,22,29",
#     "text": "じ"
# }, {
#     "boundingBox": "63,170,26,24",
#     "text": "ゃ"
# }]
# }, {
#     "boundingBox": "92,32,33,234",
#     "words": [{
#         "boundingBox": "94,32,27,23",
#     "text": "マ"
# }, {
#     "boundingBox": "96,66,27,25",
#     "text": "ン"
# }, {
#     "boundingBox": "95,96,29,30",
#     "text": "ガ"
# }, {
#     "boundingBox": "95,131,27,32",
#     "text": "を"
# }, {
#     "boundingBox": "92,166,31,32",
#     "text": "使"
# }, {
#     "boundingBox": "95,202,27,29",
#     "text": "え"
# }, {
#     "boundingBox": "94,235,31,31",
#     "text": "ば"
# }]
# }, {
#     "boundingBox": "778,299,30,63",
#     "words": [{
#         "boundingBox": "778,299,19,17",
#     "text": "方"
# }, {
#     "boundingBox": "785,318,12,11",
#     "text": "ん"
# }, {
#     "boundingBox": "784,328,20,19",
#     "text": "甘"
# }, {
#     "boundingBox": "789,348,19,14",
#     "text": "か"
# }]
# }, {
#     "boundingBox": "857,299,16,80",
#     "words": [{
#         "boundingBox": "857,299,13,14",
#     "text": "〒"
# }, {
#     "boundingBox": "858,315,11,9",
#     "text": "レ"
# }, {
#     "boundingBox": "860,326,13,11",
#     "text": "ル"
# }, {
#     "boundingBox": "858,341,12,16",
#     "text": "キ"
# }, {
#     "boundingBox": "865,361,3,18",
#     "text": "ー"
# }]
# }, {
#     "boundingBox": "904,301,16,61",
#     "words": [{
#         "boundingBox": "906,301,12,20",
#     "text": "ら"
# }, {
#     "boundingBox": "904,322,16,15",
#     "text": "は"
# }, {
#     "boundingBox": "909,342,5,20",
#     "text": "ー"
# }]
# }, {
#     "boundingBox": "533,305,24,188",
#     "words": [{
#         "boundingBox": "533,305,24,25",
#     "text": "読"
# }, {
#     "boundingBox": "534,333,22,21",
#     "text": "ん"
# }, {
#     "boundingBox": "534,360,22,20",
#     "text": "で"
# }, {
#     "boundingBox": "538,384,12,23",
#     "text": "く"
# }, {
#     "boundingBox": "533,410,24,23",
#     "text": "れ"
# }, {
#     "boundingBox": "535,436,21,24",
#     "text": "な"
# }, {
#     "boundingBox": "535,465,22,19",
#     "text": "い"
# }, {
#     "boundingBox": "543,489,4,4",
#     "text": "・"
# }]
# }, {
#     "boundingBox": "564,306,24,257",
#     "words": [{
#         "boundingBox": "564,306,24,23",
#     "text": "活"
# }, {
#     "boundingBox": "564,332,24,23",
#     "text": "字"
# }, {
#     "boundingBox": "564,358,24,24",
#     "text": "離"
# }, {
#     "boundingBox": "564,384,24,23",
#     "text": "れ"
# }, {
#     "boundingBox": "565,412,22,20",
#     "text": "の"
# }, {
#     "boundingBox": "564,436,24,24",
#     "text": "若"
# }, {
#     "boundingBox": "564,462,24,24",
#     "text": "者"
# }, {
#     "boundingBox": "565,489,22,22",
#     "text": "た"
# }, {
#     "boundingBox": "566,515,20,23",
#     "text": "ち"
# }, {
#     "boundingBox": "565,541,23,22",
#     "text": "は"
# }]
# }, {
#     "boundingBox": "627,307,24,256",
#     "words": [{
#         "boundingBox": "627,307,23,21",
#     "text": "せ"
# }, {
#     "boundingBox": "632,337,18,14",
#     "text": "つ"
# }, {
#     "boundingBox": "627,359,23,21",
#     "text": "か"
# }, {
#     "boundingBox": "632,384,12,23",
#     "text": "く"
# }, {
#     "boundingBox": "627,410,24,24",
#     "text": "新"
# }, {
#     "boundingBox": "628,437,22,22",
#     "text": "人"
# }, {
#     "boundingBox": "627,464,24,22",
#     "text": "研"
# }, {
#     "boundingBox": "627,488,24,24",
#     "text": "修"
# }, {
#     "boundingBox": "627,516,22,22",
#     "text": "用"
# }, {
#     "boundingBox": "627,543,23,20",
#     "text": "の"
# }]
# }, {
#     "boundingBox": "595,309,24,280",
#     "words": [{
#         "boundingBox": "596,309,21,18",
#     "text": "マ"
# }, {
#     "boundingBox": "597,336,21,14",
#     "text": "ニ"
# }, {
#     "boundingBox": "600,364,19,13",
#     "text": "ュ"
# }, {
#     "boundingBox": "596,387,22,20",
#     "text": "ア"
# }, {
#     "boundingBox": "596,413,23,19",
#     "text": "ル"
# }, {
#     "boundingBox": "598,436,20,24",
#     "text": "を"
# }, {
#     "boundingBox": "595,463,24,23",
#     "text": "作"
# }, {
#     "boundingBox": "601,494,18,14",
#     "text": "っ"
# }, {
#     "boundingBox": "596,515,22,22",
#     "text": "た"
# }, {
#     "boundingBox": "596,543,22,20",
#     "text": "の"
# }, {
#     "boundingBox": "597,569,21,20",
#     "text": "に"
# }]
# }, {
#     "boundingBox": "840,324,19,69",
#     "words": [{
#         "boundingBox": "840,324,12,18",
#     "text": "有"
# }, {
#     "boundingBox": "841,345,13,12",
#     "text": "心"
# }, {
#     "boundingBox": "842,358,12,18",
#     "text": "才"
# }, {
#     "boundingBox": "844,378,15,15",
#     "text": "よ"
# }]
# }, {
#     "boundingBox": "721,436,25,88",
#     "words": [{
#         "boundingBox": "724,436,19,31",
#     "text": "イ"
# }, {
#     "boundingBox": "721,491,25,33",
#     "text": "尸"
# }]
# }, {
#     "boundingBox": "781,643,24,241",
#     "words": [{
#         "boundingBox": "782,643,23,23",
#     "text": "誰"
# }, {
#     "boundingBox": "783,671,21,20",
#     "text": "に"
# }, {
#     "boundingBox": "784,695,19,23",
#     "text": "も"
# }, {
#     "boundingBox": "781,721,24,24",
#     "text": "わ"
# }, {
#     "boundingBox": "782,748,23,21",
#     "text": "か"
# }, {
#     "boundingBox": "786,774,14,23",
#     "text": "り"
# }, {
#     "boundingBox": "782,800,23,22",
#     "text": "や"
# }, {
#     "boundingBox": "782,826,23,23",
#     "text": "す"
# }, {
#     "boundingBox": "786,852,13,23",
#     "text": "く"
# }, {
#     "boundingBox": "798,878,7,6",
#     "text": "、"
# }]
# }, {
#     "boundingBox": "865,643,24,154",
#     "words": [{
#         "boundingBox": "865,643,23,23",
#     "text": "文"
# }, {
#     "boundingBox": "865,669,23,23",
#     "text": "字"
# }, {
#     "boundingBox": "865,695,23,24",
#     "text": "表"
# }, {
#     "boundingBox": "865,722,24,23",
#     "text": "現"
# }, {
#     "boundingBox": "867,748,19,22",
#     "text": "よ"
# }, {
#     "boundingBox": "870,774,14,23",
#     "text": "り"
# }]
# }, {
#     "boundingBox": "750,644,24,205",
#     "words": [{
#         "boundingBox": "750,644,24,22",
#     "text": "記"
# }, {
#     "boundingBox": "750,669,24,24",
#     "text": "憶"
# }, {
#     "boundingBox": "751,697,21,20",
#     "text": "に"
# }, {
#     "boundingBox": "752,721,19,24",
#     "text": "も"
# }, {
#     "boundingBox": "750,747,24,23",
#     "text": "残"
# }, {
#     "boundingBox": "755,774,14,23",
#     "text": "り"
# }, {
#     "boundingBox": "751,800,21,23",
#     "text": "ま"
# }, {
#     "boundingBox": "750,826,23,23",
#     "text": "す"
# }]
# }, {
#     "boundingBox": "812,644,25,205",
#     "words": [{
#         "boundingBox": "814,644,18,22",
#     "text": "イ"
# }, {
#     "boundingBox": "816,672,20,19",
#     "text": "ン"
# }, {
#     "boundingBox": "812,700,24,15",
#     "text": "ハ"
# }, {
#     "boundingBox": "814,722,19,22",
#     "text": "ク"
# }, {
#     "boundingBox": "821,748,13,22",
#     "text": "ト"
# }, {
#     "boundingBox": "813,773,24,22",
#     "text": "が"
# }, {
#     "boundingBox": "815,799,21,24",
#     "text": "あ"
# }, {
#     "boundingBox": "817,826,15,23",
#     "text": "り"
# }]
# }, {
#     "boundingBox": "838,644,24,99",
#     "words": [{
#         "boundingBox": "839,644,23,22",
#     "text": "圧"
# }, {
#     "boundingBox": "838,669,24,24",
#     "text": "倒"
# }, {
#     "boundingBox": "840,695,22,23",
#     "text": "的"
# }, {
#     "boundingBox": "840,723,21,20",
#     "text": "に"
# }]
# }, {
#     "boundingBox": "891,647,24,149",
#     "words": [{
#         "boundingBox": "892,647,21,17",
#     "text": "マ"
# }, {
#     "boundingBox": "894,672,20,19",
#     "text": "ン"
# }, {
#     "boundingBox": "893,694,22,23",
#     "text": "ガ"
# }, {
#     "boundingBox": "891,721,23,24",
#     "text": "表"
# }, {
#     "boundingBox": "891,748,24,23",
#     "text": "現"
# }, {
#     "boundingBox": "892,774,22,22",
#     "text": "は"
# }]
# }, {
#     "boundingBox": "485,648,24,154",
#     "words": [{
#         "boundingBox": "486,648,23,24",
#     "text": "楽"
# }, {
#     "boundingBox": "490,676,17,21",
#     "text": "し"
# }, {
#     "boundingBox": "490,701,12,22",
#     "text": "く"
# }, {
#     "boundingBox": "485,727,24,24",
#     "text": "読"
# }, {
#     "boundingBox": "486,753,22,22",
#     "text": "め"
# }, {
#     "boundingBox": "488,780,19,22",
#     "text": "る"
# }]
# }, {
#     "boundingBox": "600,648,24,179",
#     "words": [{
#         "boundingBox": "600,648,24,21",
#     "text": "パ"
# }, {
#     "boundingBox": "603,677,20,19",
#     "text": "ン"
# }, {
#     "boundingBox": "603,704,19,19",
#     "text": "フ"
# }, {
#     "boundingBox": "605,729,18,19",
#     "text": "レ"
# }, {
#     "boundingBox": "606,757,17,17",
#     "text": "ッ"
# }, {
#     "boundingBox": "609,780,12,21",
#     "text": "ト"
# }, {
#     "boundingBox": "602,807,21,20",
#     "text": "に"
# }]
# }, {
#     "boundingBox": "627,648,23,102",
#     "words": [{
#         "boundingBox": "627,648,23,24",
#     "text": "社"
# }, {
#     "boundingBox": "628,675,21,23",
#     "text": "員"
# }, {
#     "boundingBox": "627,700,23,24",
#     "text": "教"
# }, {
#     "boundingBox": "627,726,23,24",
#     "text": "育"
# }]
# }, {
#     "boundingBox": "657,648,24,127",
#     "words": [{
#         "boundingBox": "657,648,24,24",
#     "text": "商"
# }, {
#     "boundingBox": "658,675,22,23",
#     "text": "品"
# }, {
#     "boundingBox": "657,701,24,23",
#     "text": "説"
# }, {
#     "boundingBox": "659,728,21,22",
#     "text": "明"
# }, {
#     "boundingBox": "659,755,21,20",
#     "text": "に"
# }]
# }, {
#     "boundingBox": "683,648,24,153",
#     "words": [{
#         "boundingBox": "684,648,23,23",
#     "text": "広"
# }, {
#     "boundingBox": "683,674,24,24",
#     "text": "告"
# }, {
#     "boundingBox": "685,703,21,20",
#     "text": "チ"
# }, {
#     "boundingBox": "686,729,19,21",
#     "text": "ラ"
# }, {
#     "boundingBox": "686,754,21,21",
#     "text": "シ"
# }, {
#     "boundingBox": "684,781,22,20",
#     "text": "の"
# }]
# }, {
#     "boundingBox": "454,649,24,127",
#     "words": [{
#         "boundingBox": "456,649,20,22",
#     "text": "よ"
# }, {
#     "boundingBox": "459,675,12,22",
#     "text": "く"
# }, {
#     "boundingBox": "454,700,24,24",
#     "text": "わ"
# }, {
#     "boundingBox": "455,727,23,22",
#     "text": "か"
# }, {
#     "boundingBox": "457,753,19,23",
#     "text": "る"
# }]
# }, {
#     "boundingBox": "511,649,25,152",
#     "words": [{
#         "boundingBox": "512,649,23,23",
#     "text": "漫"
# }, {
#     "boundingBox": "512,676,23,22",
#     "text": "画"
# }, {
#     "boundingBox": "512,700,23,23",
#     "text": "が"
# }, {
#     "boundingBox": "514,726,21,24",
#     "text": "あ"
# }, {
#     "boundingBox": "511,753,24,23",
#     "text": "れ"
# }, {
#     "boundingBox": "513,778,23,23",
#     "text": "ば"
# }]
# }, {
#     "boundingBox": "543,649,23,178",
#     "words": [{
#         "boundingBox": "549,649,11,21",
#     "text": "—"
# }, {
#     "boundingBox": "548,675,12,21",
#     "text": "0"
# }, {
#     "boundingBox": "543,732,23,13",
#     "text": "ヘ"
# }, {
#     "boundingBox": "553,753,3,23",
#     "text": "ー"
# }, {
#     "boundingBox": "545,778,21,23",
#     "text": "ジ"
# }, {
#     "boundingBox": "544,807,21,20",
#     "text": "に"
# }]
# }, {
#     "boundingBox": "569,728,24,99",
#     "words": [{
#         "boundingBox": "569,728,24,21",
#     "text": "サ"
# }, {
#     "boundingBox": "570,754,19,22",
#     "text": "イ"
# }, {
#     "boundingBox": "577,780,13,21",
#     "text": "ト"
# }, {
#     "boundingBox": "570,807,22,20",
#     "text": "の"
# }]
# }, {
#     "boundingBox": "19,655,27,272",
#     "words": [{
#         "boundingBox": "20,655,25,27",
#     "text": "お"
# }, {
#     "boundingBox": "20,690,25,20",
#     "text": "っ"
# }, {
#     "boundingBox": "24,716,14,27",
#     "text": "く"
# }, {
#     "boundingBox": "24,747,16,27",
#     "text": "り"
# }, {
#     "boundingBox": "21,780,25,23",
#     "text": "い"
# }, {
#     "boundingBox": "19,808,26,26",
#     "text": "た"
# }, {
#     "boundingBox": "24,840,20,25",
#     "text": "し"
# }, {
#     "boundingBox": "20,869,24,27",
#     "text": "ま"
# }, {
#     "boundingBox": "19,899,26,28",
#     "text": "す"
# }]
# }, {
#     "boundingBox": "54,655,29,409",
#     "words": [{
#         "boundingBox": "55,655,27,28",
#     "text": "本"
# }, {
#     "boundingBox": "54,685,28,28",
#     "text": "格"
# }, {
#     "boundingBox": "56,716,26,27",
#     "text": "的"
# }, {
#     "boundingBox": "56,747,25,27",
#     "text": "な"
# }, {
#     "boundingBox": "74,777,9,8",
#     "text": "、"
# }, {
#     "boundingBox": "60,791,22,27",
#     "text": "ビ"
# }, {
#     "boundingBox": "57,822,25,27",
#     "text": "ジ"
# }, {
#     "boundingBox": "56,854,25,26",
#     "text": "ネ"
# }, {
#     "boundingBox": "56,887,24,22",
#     "text": "ス"
# }, {
#     "boundingBox": "57,921,21,18",
#     "text": "コ"
# }, {
#     "boundingBox": "60,947,17,24",
#     "text": "ミ"
# }, {
#     "boundingBox": "62,981,20,19",
#     "text": "ッ"
# }, {
#     "boundingBox": "57,1007,21,26",
#     "text": "ク"
# }, {
#     "boundingBox": "57,1037,24,27",
#     "text": "を"
# }]
# }, {
#     "boundingBox": "90,655,29,392",
#     "words": [{
#         "boundingBox": "90,655,28,27",
#     "text": "経"
# }, {
#     "boundingBox": "90,686,28,27",
#     "text": "験"
# }, {
#     "boundingBox": "90,716,28,27",
#     "text": "豊"
# }, {
#     "boundingBox": "91,746,27,28",
#     "text": "富"
# }, {
#     "boundingBox": "92,777,25,27",
#     "text": "な"
# }, {
#     "boundingBox": "94,806,25,27",
#     "text": "プ"
# }, {
#     "boundingBox": "95,843,19,19",
#     "text": "ロ"
# }, {
#     "boundingBox": "91,872,26,23",
#     "text": "の"
# }, {
#     "boundingBox": "92,904,24,20",
#     "text": "マ"
# }, {
#     "boundingBox": "94,933,23,23",
#     "text": "ン"
# }, {
#     "boundingBox": "92,959,27,27",
#     "text": "ガ"
# }, {
#     "boundingBox": "91,991,26,28",
#     "text": "家"
# }, {
#     "boundingBox": "91,1021,28,26",
#     "text": "が"
# }]
# }, {
#     "boundingBox": "676,957,15,12",
#     "words": [{
#         "boundingBox": "676,957,15,12",
#     "text": "し"
# }]
# }, {
#     "boundingBox": "572,975,26,74",
#     "words": [{
#         "boundingBox": "572,975,21,16",
#     "text": "ハ"
# }, {
#     "boundingBox": "576,1002,14,12",
#     "text": "7"
# }, {
#     "boundingBox": "574,1027,24,22",
#     "text": "ワ"
# }]
# }]
# }]
# }