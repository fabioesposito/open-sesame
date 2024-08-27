import gleam/dynamic
import gleam/hackney
import gleam/http
import gleam/http/request
import gleam/io
import gleam/json
import gleam/string

pub type Auth0Config {
  Auth0Config(
    domain: String,
    client_id: String,
    client_secret: String,
    redirect_uri: String,
  )
}

pub fn create_user(config: Auth0Config, email: String, password: String) {
  let body =
    json.object([
      #("email", json.string(email)),
      #("password", json.string(password)),
      #("connection", json.string("Username-Password-Authentication")),
    ])
    |> json.to_string

  let req =
    request.new()
    |> request.set_scheme(http.Https)
    |> request.set_host(config.domain)
    |> request.set_method(http.Post)
    |> request.set_header("Content-Type", "application/json")
    |> request.set_header(
      "Authorization",
      "Bearer " <> get_management_api_token(config),
    )
    |> request.set_path("/api/v2/users")
    |> request.set_body(body)

  case hackney.send(req) {
    Ok(response) ->
      case response.status {
        201 -> Ok(Nil)
        _ -> Error(response.body)
      }
    Error(e) -> {
      io.debug(e)
      Error("unable to make request")
    }
  }
}

pub fn login(config: Auth0Config, email: String, password: String) {
  let body =
    json.object([
      #("grant_type", json.string("password")),
      #("username", json.string(email)),
      #("password", json.string(password)),
      #("client_id", json.string(config.client_id)),
      #("client_secret", json.string(config.client_secret)),
    ])
    |> json.to_string

  let req =
    request.new()
    |> request.set_scheme(http.Https)
    |> request.set_host(config.domain)
    |> request.set_method(http.Get)
    |> request.set_header("Content-Type", "application/json")
    |> request.set_path("/oauth/token")
    |> request.set_body(body)

  case hackney.send(req) {
    Ok(response) ->
      case response.status {
        200 -> {
          let body_string = response.body
          case
            json.decode(
              body_string,
              dynamic.field("access_token", dynamic.string),
            )
          {
            Ok(token) -> Ok(token)
            Error(_) -> Error("Failed to parse token from response")
          }
        }
        _ -> Error("Login failed")
      }
    Error(_) -> Error("unable to make request")
  }
}

pub fn logout(config: Auth0Config, token: String) {
  let url = string.concat([config.domain, "/v2/logout"])
  let query = [
    #("client_id", config.client_id),
    #("returnTo", config.redirect_uri),
  ]

  let assert Ok(request) = request.to(url)

  request
  |> request.prepend_header("Content-Type", "application/json")
  |> request.prepend_header("Authorization", "Bearer " <> token)
  |> request.set_query(query)

  case hackney.send(request) {
    Ok(response) ->
      case response.status {
        200 -> Ok(Nil)
        _ -> Error("Logout failed")
      }
    Error(_) -> Error("unable to make request")
  }
}

fn get_management_api_token(_config: Auth0Config) -> String {
  // Implementation to get a management API token
  // This is a placeholder and should be implemented properly
  "management_api_token"
}
