## Create simple dummy data ----
d <- data.frame(g1=factor(c("A","A","A","B","B","B","C","C","C")),
                g2=factor(c("a","b","c","a","b","c","a","b","c")),
                g3=factor(c("x","x","x","x","x","y","y","y","y")),
                dat=1:9,junk=11:19)


## Test Messages ----
test_that("sumTable() messages",{
  expect_error(sumTable(dat+junk~g1+g2,data=d),
               "Function does not work with more than one variable on")
  expect_error(sumTable(dat~g1+g2+g3,data=d),
               "'sumTable' requires one quantitative variable on")
  expect_error(sumTable(~g1,data=d),
               "'sumTable' requires one quantitative variable on")
  expect_warning(sumTable(dat~junk,data=d),
                 "RHS variable was converted to a factor")
  expect_warning(sumTable(dat~g1+junk,data=d),
                 "Second RHS variable was converted to a factor.")
  expect_warning(sumTable(dat~junk+g1,data=d),
                 "First RHS variable was converted to a factor")
})


## Test Output Types ----


## Validate Results ----
test_that("SumTable() Results",{
  # 1-D example of mean
  tmp <- sumTable(dat~g1,data=d)
  expect_equal(class(tmp),"array")
  expect_equal(mode(tmp),"numeric")
  expect_equal(tmp,array(c(2,5,8),dimnames=list(c("A","B","C"))))
  # 1-D example of mean
  tmp <- sumTable(dat~g2,data=d)
  expect_equal(class(tmp),"array")
  expect_equal(mode(tmp),"numeric")
  expect_equal(tmp,array(c(4,5,6),dimnames=list(c("a","b","c"))))
  # 2-D example of mean
  tmp <- sumTable(dat~g1*g2,data=d)
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),3)
  expect_equal(ncol(tmp),3)
  expect_equal(tmp,matrix(1:9,nrow=3,byrow=TRUE),ignore_attr=TRUE)
  # 1-D example of length
  tmp <- sumTable(dat~g1,data=d,FUN=length)
  expect_equal(class(tmp),"array")
  expect_equal(mode(tmp),"numeric")
  expect_equal(tmp,array(c(3,3,3),dimnames=list(c("A","B","C"))))
  # 2-D example of length
  tmp <- sumTable(dat~g1*g2,data=d,FUN=length)
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),3)
  expect_equal(ncol(tmp),3)
  expect_equal(tmp,matrix(1,nrow=3,ncol=3,byrow=TRUE),ignore_attr=TRUE)
  # 1-D example of sd
  tmp <- sumTable(dat~g1,data=d,FUN=sd)
  expect_equal(class(tmp),"array")
  expect_equal(mode(tmp),"numeric")
  expect_equal(tmp,array(c(1,1,1),dimnames=list(c("A","B","C"))))
  # 2-D example of sd
  tmp <- sumTable(dat~g1*g2,data=d,FUN=sd)
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),3)
  expect_equal(ncol(tmp),3)
  expect_equal(tmp,matrix(NA_real_,nrow=3,ncol=3,byrow=TRUE),ignore_attr=TRUE)
})
