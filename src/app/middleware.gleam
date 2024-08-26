import wisp.{type Request, type Response}

pub fn middleware(
  req: Request,
  handle_request: fn(Request) -> Response,
) -> Response {
  let assert Ok(priv) = wisp.priv_directory("open_sesame")

  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.serve_static(req, under: "/static", from: priv)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  handle_request(req)
}
