# OAuth2/Phoenix Example Application

> This is an example application showing how one can integrate with the
> [OAuth2](https://github.com/scrogson/oauth2) library and
> the [Phoenix](https://github.com/phoenixframework/phoenix) framework.

![Alt text](https://monosnap.com/file/PahR5zCiU9EapeRyuvAKn1AyTitp1p.png)

To start the application:

1. 1. Register a new application with [Fitbit](https://dev.fitbit.com/apps)
    - Choose 'Client' for OAuth 2.0 Application Type
    - Enter http://lvh.me:4000/auth/callback for the Authorization callback URL
    - Choose 'Read-Only' for Default Access Type
2. Set the `REDIRECT_URI` environment variable to the callback URL
3. Set the `CLIENT_ID` and `CLIENT_SECRET` environment variables
4. Install Elixir dependencies with `mix deps.get`
5. Install NodeJS dependencies with `npm install`
6. Start Phoenix router with `mix phoenix.server`

Now you can visit `lvh.me:4000` from your browser and click "Sign in with
Fitbit".

After authorizing the application, you should see the welcome message above.

To revoke access, clear any browser cookies and visit
https://www.fitbit.com/user/profile/apps

References
* https://wiki.fitbit.com/display/API/OAuth+2.0
* https://community.fitbit.com/t5/Web-API/bd-p/dev
