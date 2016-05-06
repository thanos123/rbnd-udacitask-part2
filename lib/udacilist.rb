class UdaciList
  include CommandLineReporter
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
  def delete(*indexes)
    indices_list = *indexes
    @items.delete_if.with_index {|_, index| indices_list.include? index + 1}
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
  # prints a table of the items usinf the CommandLineReporter gem
  def print_table(items)
    table(:border => true) do
      row do
        column('#', :width => 3)
        column('TYPE', :width => 10)
        column('DETAILS', :width => 70)
      end
      items.each_with_index do |item, position|
        row do
          column(position+1)
          column(@@item_class_names.key(item.class.name))
          column(item.details)
        end
      end
    end
  end
  def all
    print_title()
    print_table(@items)
  end
  # filters items by type
  # it can also filter the from date
  def filter(type, date_from = nil)
    check_type(type)
    print_title("type: "+type)
    type_items = @items.select{ |item| item.class.name == @@item_class_names[type]}
    raise UdaciListErrors::TypeHasNoItems, "There aren't any items of type #{type}." if type_items.count < 1
    print_table(type_items)
  end
end
