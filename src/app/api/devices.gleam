import gleam/http.{Get}
import gleam/string_builder
import wisp.{type Request}

pub fn handle_request(req: Request) {
  case req.method {
    http.Get -> get_devices()
    _ -> wisp.method_not_allowed([Get])
  }
}

fn get_devices() {
  wisp.response(200)
  |> wisp.json_body(string_builder.from_string("[{},{}]"))
}
