defmodule RecommendersWeb.Schema do
  use Absinthe.Schema

  # Types
  import_types(RecommendersWeb.Schema.Types.{Accounts, Content})

  # Mutations
  import_types(RecommendersWeb.Schema.Mutations.{Accounts, Content})

  # Queries
  import_types(RecommendersWeb.Schema.Queries.{Accounts, Content})

  query do
    # Accounts
    import_fields(:accounts_queries)

    # Content
    import_fields(:content_queries)
  end

  mutation do
    # Accounts
    import_fields(:accounts_mutations)

    # Content
    import_fields(:content_mutations)
  end
end
