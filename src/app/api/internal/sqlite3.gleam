import gleam/dynamic
import sqlight

pub fn init_db() {
  use conn <- sqlight.with_connection(":memory:")
  // use conn <- sqlight.with_connection("mydata.db")
  let cat_decoder = dynamic.tuple2(dynamic.string, dynamic.int)

  let sql =
    "
  create table cats (name text, age int);

  insert into cats (name, age) values 
  ('Nubi', 4),
  ('Biffy', 10),
  ('Ginny', 6);
  "
  let assert Ok(Nil) = sqlight.exec(sql, conn)

  let sql =
    "
  select name, age from cats
  where age < ?
  "
  let assert Ok([#("Nubi", 4), #("Ginny", 6)]) =
    sqlight.query(sql, on: conn, with: [sqlight.int(7)], expecting: cat_decoder)
}
