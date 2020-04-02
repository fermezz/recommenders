defmodule Recommenders.Context do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} ->
        put_private(conn, :absinthe, %{context: context})

      _ ->
        conn
    end
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      {:ok, %{current_user: current_user, token: token}}
    end
  end

  defp authorize(token) do
    with {:ok, claims} <- Recommenders.Guardian.decode_and_verify(token) do
      case Recommenders.Guardian.resource_from_claims(claims) do
        {:ok, user} -> {:ok, user}
        error -> error
      end
    end
  end
end
