class UdaciList
  attr_reader :title, :items
  @@item_class_names = {"todo" => "TodoItem", "event" => "EventItem", "link" => "LinkItem"}

  def initialize(options={})
    @title = options.key?(:title) ? options[:title] : "Untitled List"
    @items = []
  end
  def add(type, description, options={})
    type = type.downcase
    check_type(type)
    @items.push Object.const_get(@@item_class_names[type]).new(description, options)
  end
  def delete(index)
    if index > @items.count
      raise UdaciListErrors::IndexExceedsListSize, "Index #{index} exceeds the size of the list"
    end
    @items.delete_at(index - 1)
  end
  # checks if type exists and raises error if it doesn't
  def check_type(type)
    if ! @@item_class_names.has_key?(type)
      raise UdaciListErrors::InvalidItemType, "Type #{type} is invalid." 
    end 
  end
  def print_title(subtitle = "")
    title = @title
    title += " - " + subtitle if subtitle != ""
    puts "-" * title.length
    puts title
    puts "-" * title.length
  end
  def all
    print_title()
    @items.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end
  def filter(type)
    check_type(type)
    print_title("type: "+type)
    type_items = @items.select{ |item| item.class.name == @@item_class_names[type]}
    type_items.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end
end
