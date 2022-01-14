class TagSelector
  include Service

  def call
=begin
    tags = Tag.all.map{|tag| tag.name}
    count = tags.size
    # Green socks tag have a bug so filtered
    tags = tags.filter {|item| item != "green"}
    result = []
    for @i in 0..count-1
      result.append(tags.fetch(@i))
    end
    result = result.sort{|a, b| a <=> b }
=end
    sql = <<-"EOS"
      SELECT tags.name as name, count(DISTINCT socks.sock_id) as count FROM socks
      INNER JOIN sock_tags ON socks.sock_id = sock_tags.sock_id
      INNER JOIN tags ON sock_tags.tag_id = tags.tag_id
      GROUP BY tags.name
    EOS
    result = ActiveRecord::Base.connection.select_all(sql).to_a
    return result
  end

end