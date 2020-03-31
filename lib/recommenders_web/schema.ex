defmodule RecommendersWeb.Schema do
  use Absinthe.Schema

  # Types
  import_types(RecommendersWeb.Schema.Types.{Accounts, Content})

  # Mutations
  import_types(RecommendersWeb.Schema.Mutations.Accounts)

  # Queries
  import_types(RecommendersWeb.Schema.Queries.{Accounts, Content})

  query do
    # Accounts
    import_fields(:accounts_queries)

    # Content
    import_fields(:recommendations_queries)
  end

  mutation do
    import_fields(:accounts_mutations)
  end
end
