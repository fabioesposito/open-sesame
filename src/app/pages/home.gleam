import nakai/attr
import nakai/html

pub fn home() {
  html.h1([], [
    html.h1_text([], "H1 Open Sesame"),
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
