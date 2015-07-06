require Logger

defmodule OAuth2Example.AuthController do
  use OAuth2Example.Web, :controller

  plug :action

  @doc """
  This action is reached via `/auth` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, _params) do
    redirect conn, external: Fitbit.authorize_url!(scope: "sleep settings")
  end

  @doc """
  This action is reached via `/auth/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"code" => code}) do
    # Exchange an auth code for an access token
    Logger.info "******THE CODE IS*****"
    Logger.info code
    token = Fitbit.get_token!(code: code)
    Logger.info "******THE TOKEN IS*****"
    Logger.info inspect(token)

    # Request the user's data with the access token
    user = OAuth2.AccessToken.get!(token, "/user")
    Logger.info "*****THE USER IS****"
    Logger.info user

    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    #
    # If you need to make additional resource requests, you may want to store
    # the access token as well.
    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, token.access_token)
    |> redirect(to: "/")
  end
end

