import app/api/devices.{devices_api}
import app/layout
import app/middleware
import app/pages/home.{home}
import app/partials/hello_text.{hello}
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req <- middleware.middleware(req)

  case wisp.path_segments(req) {
    [] -> layout.render_page(home())
    // TODO make partials dynamic
    ["partials", "hello-text"] -> layout.render_partial(hello())
    ["api", "devices"] -> devices_api(req)
    _ -> wisp.not_found()
  }
}
