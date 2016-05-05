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
  def details
    format_description(@description) + "due: " +
    format_date(@due) +
    format_priority(@priority)
  end
end
