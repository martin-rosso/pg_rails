module Arel
  module Predications
    def matches_unaccent(other, escape = nil, case_sensitive = false)
      left = Arel::Nodes::NamedFunction.new('unaccent', [self])
      right = Arel::Nodes::NamedFunction.new('unaccent',
                                             [Arel::Nodes::Quoted.new(other)])
      left.matches(right)
    end

    def matches_unaccent_any(others, escape = nil, case_sensitive = false)
      grouping_any :matches_unaccent, others, escape, case_sensitive
    end

    def matches_unaccent_all(others, escape = nil, case_sensitive = false)
      grouping_all :matches_unaccent, others, escape, case_sensitive
    end

    def does_not_match_unaccent(other)
      left = Arel::Nodes::NamedFunction.new('unaccent', [self])
      right = Arel::Nodes::NamedFunction.new('unaccent',
                                             [Arel::Nodes::Quoted.new(other)])
      left.does_not_match(right)
    end
  end
end

Ransack.configure do |config|
  config.postgres_fields_sort_option = :nulls_always_last

  config.custom_arrows = {
    up_arrow: '<i class="bi bi-sort-up" />',
    down_arrow: '<i class="bi bi-sort-down-alt" />',
    default_arrow: ''
  }

  # Piso predicados cont y not_cont para que usen unaccent
  config.add_predicate 'cont',
    arel_predicate: 'matches_unaccent',
    formatter: proc { |v| "%#{Ransack::Constants.escape_wildcards(v.downcase)}%" },
    case_insensitive: true

  config.add_predicate 'cont_any',
    arel_predicate: 'matches_unaccent_any',
    formatter: proc { |v| v.split(' ').map { "%#{Ransack::Constants.escape_wildcards(_1.downcase)}%" } },
    case_insensitive: true

  config.add_predicate 'cont_all',
    arel_predicate: 'matches_unaccent_all',
    formatter: proc { |v| v.split(' ').map { "%#{Ransack::Constants.escape_wildcards(_1.downcase)}%" } },
    case_insensitive: true

  config.add_predicate 'not_cont',
    arel_predicate: 'does_not_match_unaccent',
    formatter: proc { |v| "%#{Ransack::Constants.escape_wildcards(v.downcase)}%" },
    case_insensitive: true

  config.add_predicate 'arr_cont', arel_predicate: 'contains', formatter: proc { |v| [v] }
end
