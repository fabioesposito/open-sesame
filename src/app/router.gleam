import app/api/auth
import app/api/devices
import app/layout
import app/middleware
import app/pages/home.{home}
import app/partials/hello_text.{hello}
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req <- middleware.middleware(req)

  case wisp.path_segments(req) {
    // Html
    [] -> layout.render_page(home())
    ["partials", "hello-text"] -> layout.render_partial(hello())

    // API
    ["api", "login"] -> auth.handle_login(req)
    ["api", "logout"] -> auth.handle_logout(req)
    ["api", "devices"] -> devices.handle_request(req)

    _ -> wisp.not_found()
  }
}
