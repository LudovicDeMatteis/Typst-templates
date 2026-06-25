#let set1 = $bb(R)$
#let q = $q$
#let ddot(body) = {
  $dot.double(body)$
}
#let SE3 = $S E(3)$
#let cross(body) = {
  $[body]_times$
}
#let crossdual(body) = {
  $[body]_(times^*)$
}
#let Log = $"Log"$

#let expon(prev, next, body) = {
  $#hide[.]^prev body_next$
}
#let motion(prev, next) = {
  $expon(prev, next, M)$
}
#let vel(prev, next) = {
  $expon(prev, next, nu)$
}
#let adjoint(prev, next) = {
  $expon(prev, next, X)$
}
#let acc(prev, next) = {
  $expon(prev, next, a)$
}
