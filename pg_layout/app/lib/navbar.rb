class Navbar
  include Rails.application.routes.url_helpers
  def default_url_options
    if Current.active_user_account.present?
      { tenant_id: Current.active_user_account.to_param }
    else
      { tenant_id: nil }
    end
  end

  attr_reader :extensiones
  attr_accessor :logo, :logo_xl, :logo_xl_url

  def initialize
    @user = Current.user
    @yaml_data = ActiveSupport::HashWithIndifferentAccess.new({})
    @extensiones = []
  end

  def add_html(html)
    @extensiones << html
  end

  def add_item(key, obj)
    @yaml_data[key] ||= []
    @yaml_data[key] << ActiveSupport::HashWithIndifferentAccess.new(obj)
  end

  def sidebar
    # FIXME: hacer mejor
    initialize
    PgEngine.configuracion.navigators.each do |navigator|
      navigator.configure(self)
    end

    ret = bar(@user.present? ? 'sidebar.signed_in' : 'sidebar.not_signed_in')
    ret.push(*bar('sidebar.developer')) if Current.namespace == :admin
    ret
  end

  def bar(key)
    bar_data = @yaml_data[key]
    return [] if bar_data.blank?

    # rubocop:disable Security/Eval
    # rubocop:disable Style/MultilineBlockChain:
    orig_idx = 0
    bar_data.map do |item|
      orig_idx += 1
      {
        title: item['name'],
        attributes: item['attributes']&.html_safe,
        path: eval(item['path']),
        show: item['policy'] ? eval(item['policy']) : true,
        priority: item['priority'] || 999_999,
        orig_idx:
      }
    end.sort_by { |a| [a[:priority], a[:orig_idx]] }
    # rubocop:enable Security/Eval
    # rubocop:enable Style/MultilineBlockChain:
  end

  def all_children_hidden?(entry)
    entry[:children].all? { |child| child[:show] == false }
  end

  def any_children_active?(entry, request)
    entry[:children].any? { |child| active_entry?(child, request) }
    true
    # TODO: quitar
  end

  def hide_entry?(entry)
    if entry[:children].present?
      all_children_hidden?(entry)
    else
      entry[:show] == false
    end
  end

  def custom_current_page?(path, request)
    current_route = Rails.application.routes.recognize_path(request.env['PATH_INFO'])
    test_route = Rails.application.routes.recognize_path(path)
    current_route[:controller] == test_route[:controller] && current_route[:action] == test_route[:action]
  rescue ActionController::RoutingError
    false
  end

  def active_entry?(entry, request)
    if entry[:children].present?
      any_children_active?(entry, request)
    elsif entry[:path].present?
      custom_current_page?(entry[:path], request)
    end
  end

  private

  def policy(clase)
    Pundit.policy(@user, clase)
  end
end
