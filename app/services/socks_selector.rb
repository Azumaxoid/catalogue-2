class SocksSelector
  include Service

  def initialize(tags, pageNum, pageSize, order)
    @tags = tags
    @pageNum = pageNum
    @pageSize = pageSize
    @order = order
  end

  def call
    @socks = []
    @tags = @tags.split(',')
    if @tags.length > 0
      @socks = Sock.find_by_sock_id(SockTag.find_by_tag_id(Tag.find_by_name(@tags).tag_id).sock_id)
    else
      @socks = Sock.all
    end
    if !@pageSize.nil?
      @socks = @socks.slice((@pageNum - 1) * @pageSize.to_i, @pageSize) || []
    end
    return @socks.map { |sock| {
      "id": sock.sock_id,
      "name": sock.name,
      "description": sock.description,
      "price": sock.price,
      "count": sock.count,
      "imageUrl": [sock.image_url_1, sock.image_url_2]
    } }
  end
end