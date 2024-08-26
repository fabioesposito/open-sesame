import nakai
import nakai/attr
import nakai/html
import wisp

pub fn layout(page: html.Node) {
  let layout =
    html.Html([], [
      html.Doctype("html"),
      html.Head([
        html.meta([attr.charset("UTF-8")]),
        html.meta([
          attr.name("viewport"),
          attr.content("width=device-width, initial-scale=1.0"),
        ]),
        html.title("Open Sesame"),
        html.Script([attr.src("https://unpkg.com/htmx.org@2.0.2")], ""),
        html.link([
          attr.rel("stylesheet"),
          attr.href(
            "https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css",
          ),
          attr.integrity(
            "sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls",
          ),
          attr.crossorigin("anonymous"),
        ]),
      ]),
      html.Body([], [page]),
    ])

  layout
}

pub fn render_page(page: html.Node) {
  let content =
    page
    |> layout
    |> nakai.to_inline_string_builder

  wisp.ok()
  |> wisp.html_body(content)
}

pub fn render_partial(partial: html.Node) {
  let content =
    partial
    |> nakai.to_inline_string_builder

  wisp.ok()
  |> wisp.html_body(content)
}
