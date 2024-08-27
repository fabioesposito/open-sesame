import gleam/http
import gleam/string_builder
import wisp.{type Request}

pub fn handle_login(req: Request) {
  case req.method {
    http.Post -> login()
    _ -> wisp.method_not_allowed([http.Post])
  }
}

fn login() {
  wisp.response(200)
  |> wisp.json_body(string_builder.from_string("[{},{}]"))
}

pub fn handle_logout(req: Request) {
  case req.method {
    http.Post -> logout()
    _ -> wisp.method_not_allowed([http.Post])
  }
}

fn logout() {
  wisp.response(200)
  |> wisp.json_body(string_builder.from_string("[{},{}]"))
}
