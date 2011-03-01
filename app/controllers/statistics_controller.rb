# encoding: UTF-8
class StatisticsController < ApplicationController

  def prizes
    @year  = params[:year]  || ("%04d" % Date.today.year)
    @month = params[:month] || ("%02d" % Date.today.month)
    @date  = Date.strptime("#{@year}-#{@month}-01")

    # 3 different ways to find the top news:
    # 1. Full SQL (returns an array of Hashes, not instantiated objects)
    # See http://rubydoc.info/docs/rails/3.0.0/ActiveRecord/ConnectionAdapters/DatabaseStatements#select_all-instance_method
    @news_top = ActiveRecord::Base.connection.select_all("SELECT * FROM news WHERE id=1")

    # 2. Find by SQL way
    # See http://rubydoc.info/docs/rails/3.0.0/ActiveRecord/Base#find_by_sql-class_method
    @news_top = News.find_by_sql(["SELECT news.* FROM news JOIN nodes ON news.id = nodes.content_id WHERE nodes.content_type='News' AND SUBSTRING(nodes.created_at,1,6)=? ORDER BY nodes.score DESC LIMIT 20", "#{@year}#{@month}"])

    # 3. ORM
    # See http://rubydoc.info/docs/rails/3.0.0/ActiveRecord/Base
    @news_top = Node.public_listing('News', 'score').    # public_listing is defined at app/models/node.rb:36
                     where(:created_at => @date..@date.end_of_month).
                     limit(20).
                     map(&:content)
  end

end
