class SearchController < ApplicationController
  def search
    @keyword = params["search"]["keyword"]         #データを代入
    @how = params["search"]["how"]             #データを代入
    @datas = search_for(@how, @keyword)          #def search_forを実行(引数に検索ワードと検索方法)
  end

  private

  def match(keyword)
    #.orを使用することで、keywordに一致するカラムのデータをnameカラムとgenre_idカラムから探してきます。
    Item.where(name: keyword).or(Item.where(genre_id: keyword))
  end

  def forward(keyword)                              #forward以降は商品名検索の定義しかしてません。
    Item.where("name LIKE ?", "#{keyword}%")        
  end

  def backward(keyword)
    Item.where("name LIKE ?", "%#{keyword}")
  end

  def partical(keyword)
    Item.where("name LIKE ?", "%#{keyword}%")
  end


  def search_for(how, keyword)
    case how                     #引数のhowと一致する処理に進むように定義しています。
    when 'match'                 #ジャンル検索の場合はmatchで固定してるので、必ず'match'の処理に進みます。
      match(keyword)
    when 'forward'
      forward(keyword)
    when 'backward'
      backward(keyword)
    when 'partical'
      partical(keyword)
    end
  end
end
