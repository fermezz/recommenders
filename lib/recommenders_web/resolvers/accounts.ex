defmodule RecommendersWeb.Resolvers.Accounts do
  def create_user(args, _resolution) do
    Recommenders.Accounts.create_user(args)
  end
end
