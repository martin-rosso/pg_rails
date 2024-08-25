module PgEngine
  class Bootstrap5BreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
    def render
      @elements.collect do |element|
        render_element(element)
      end.join(@options[:separator] || '')
    end

    def render_element(element)
      content = if element.path.nil?
                  compute_name(element)
                else
                  # TODO: add aria-current="page"
                  @context.link_to_unless_current(
                    compute_name(element), compute_path(element), element.options
                  )
                end

      @context.content_tag('li', content, class: 'breadcrumb-item')
    end
  end
end
