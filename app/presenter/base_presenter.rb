class BasePresenter
  def initialize(object, template)
    @object = object
    @template = template
  end

private

  def handle_none(value)
    if value.present?
      yield
    else
      h.content_tag :span, "None given", class: "none"
    end
  end

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def h
    @template
  end

  def method_missing(*args, &block)
    @template.send(*args, &block)
  end

  def standard_title
    t '.title', :default => @object.class.model_name.human.titleize + ": "  + @object.name
  end
end
