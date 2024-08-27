import nakai/attr
import nakai/html

pub fn home() {
  html.section([], [
    html.h1_text([], "Open Sesame"),
    html.div([], [
      html.p_text([attr.id("hello-text")], "Hello, world!"),
      html.button_text(
        [
          attr.Attr("hx-get", "/partials/hello-text"),
          attr.Attr("hx-target", "#hello-text"),
        ],
        "Click Me!",
      ),
    ]),
  ])
}
