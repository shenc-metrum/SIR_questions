setClass("A")
setClass("B")
setClassUnion("AB", members = c("A", "B"))


setClass("mle2", contains = "mle")
setClassUnion("mleA", members = c("mle", "A"))
setClassUnion("mle2A", members = c("mle2", "A"))

setClassUnion("AOrNull", members = c("A", "NULL"))
setClassUnion("BOrNull", members = c("B", "NULL"))
