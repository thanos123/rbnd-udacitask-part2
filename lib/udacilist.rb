class UdaciList
  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title]
    @items = []
  end
  def add(type, description, options={})
    case type.downcase
    when "todo"
      @items.push TodoItem.new(description, options) 
    when "event"
      @items.push EventItem.new(description, options) 
    when "link"
      @items.push LinkItem.new(description, options)
    else
      raise UdaciListErrors::InvalidItemType, "Type #{type} is invalid." 
    end
  end
  def delete(index)
    if index > @items.count
      raise UdaciListErrors::IndexExceedsListSize, "Index #{index} exceeds the size of the list"
    end
    @items.delete_at(index - 1)
  end
  def all
    puts "-" * @title.length
    puts @title
    puts "-" * @title.length
    @items.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end
end
