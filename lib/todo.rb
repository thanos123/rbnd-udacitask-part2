class TodoItem
  include Listable
  attr_reader :description, :due, :priority
  @@valid_priorities = ["high", "medium", "low", nil]

  def initialize(description, options={})
    @description = description
    @due = options[:due] ? Chronic.parse(options[:due]) : options[:due]
    priority = options[:priority]
    if ! @@valid_priorities.include?(priority)
      raise UdaciListErrors::InvalidPriorityValue, "Priority #{priority} is invalid."
    end
    @priority = priority
  end
  # overrides Listable
  # gets the formatted date from listable and highlights it if it's today
  def format_date()
    due_text = super(@due)
    # highlight today's date
    if @due and @due.strftime("%d %m %y") == Time.now.strftime("%d %m %y")
      return due_text.black.on_yellow
    end
    due_text
  end
  def details
    format_description(@description) + "due: " +
    format_date +
    format_priority(@priority)
  end
end
