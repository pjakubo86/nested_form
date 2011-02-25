module NestedForm
  class Builder < ActionView::Helpers::FormBuilder
    def link_to_add(name, association, html_options = {})
      @fields ||= {}
      @template.after_nested_form(association) do
        model_object = object.class.reflect_on_association(association).klass.new
        output = %Q[<div id="#{association}_fields_blueprint" style="display: none">].html_safe
        output << fields_for(association, model_object, :child_index => "new_#{association}", &@fields[association])
        output.safe_concat('</div>')
        output
      end
      #@template.link_to(name, "javascript:void(0)", :class => "add_nested_fields", "data-association" => association, html_options.merge!{html_options})
      linkclass = "add_nested_fields"
      if html_options.has_key?(:class)
        html_options[:class] << " #{linkclass}"
      else
        html_options.merge!({:class => linkclass})
      end
      html_options.merge!({"data-association" => association})
      @template.link_to(name, "javascript:void(0)", html_options)
    end
    
    def link_to_remove(name)
      hidden_field(:_destroy) + @template.link_to(name, "javascript:void(0)", :class => "remove_nested_fields")
    end
    
    
    def fields_for_with_nested_attributes(association, args, block)
      @fields ||= {}
      @fields[association] = block
      super
    end

    
    def fields_for_nested_model(name, association, args, block)
      output = '<div class="fields">'.html_safe
      output << super
      output.safe_concat('</div>')
      output
    end
  end
end
