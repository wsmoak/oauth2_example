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
    #Logger.debug "******THE CODE IS: " <> code
    token = Fitbit.get_token!(code: code)
    #Logger.debug "******THE TOKEN IS: " <> inspect(token)

    # Request the user's data with the access token
    user = OAuth2.AccessToken.get!(token, "/1/user/-/profile.json")
    #Logger.debug "*****THE USER IS: " <> inspect(user)

    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    #
    # If you need to make additional resource requests, you may want to store
    # the access token as well.
    #Logger.debug "*****conn is: " <> inspect(conn)

    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, token.access_token)
    |> IO.inspect
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/auth/callback` and is the the callback
  URL that Fitbit will redirect the user back to. If the user has
  denied the request, there will be an 'error' and 'error_message'
  in the parameters.
  """
  def callback(conn, params = %{ "error" => error }) do
    #Logger.debug "*****matched on error, conn is" <> inspect(conn)
    conn
    |> put_session(:error, error)
    |> put_session(:error_message, params["error_description"])
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/auth/callback` and is the the callback
  URL that Fitbit will redirect the user back to.  If neither 'code'
  nor 'error' were present in the request, we'll end up here.
  """
  def callback(conn, _params) do
    #Logger.debug "***** no code or error, in generic callback."
    #Logger.debug "conn is: " <> inspect(conn)

    conn
    |> redirect(to: "/")
  end
end

