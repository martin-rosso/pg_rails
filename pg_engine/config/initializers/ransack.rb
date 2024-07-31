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
end
