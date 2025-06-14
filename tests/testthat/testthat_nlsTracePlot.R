## Get results for testing ----
vb1 <- suppressWarnings( vbFuns() )
fit1 <- nls(tl~vb1(age,Linf,K,t0),data=SpotVA1,start=list(Linf=12,K=0.3,t0=0))
fit3 <- lm(tl~age,data=SpotVA1)

## Test Messages ----
test_that("nlsTracePlot() test messages",{
  # wrong type
  expect_error(nlsTracePlot(fit3,bh1),"must be from")
  # no fun
  expect_error(nlsTracePlot(fit1),"missing, with no default")
  # bad pallette choice
  expect_error(nlsTracePlot(fit1,vb1,col="derek"),"is not a valid color or palette")
  # bad n
  expect_error(nlsTracePlot(fit1,vb1,n=1),"'n' must be greater than 2")
  # bad legend
  expect_error(nlsTracePlot(fit1,vb1,legend="derek"),"Must use proper keyword")
})

## Test Output Types ----
test_that("nlsTracePlot() test output",{
  # successful fit
  tmp <- nlsTracePlot(fit1,vb1,add=FALSE)
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(ncol(tmp),3)
  # unsuccessful fit
  data(BSkateGB,package="FSAdata")
  wtr <- droplevels(subset(BSkateGB,season=="winter"))
  bh1 <- srFuns()
  trc <- capture.output(try(
    expect_error(fit2 <- nls(recruits~bh1(spawners,a,b),wtr,
                             start=srStarts(recruits~spawners,data=wtr),
                             trace=TRUE))
  ))
  tmp <- nlsTracePlot(trc,bh1,add=FALSE)
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(ncol(tmp),2)
})


## Validate Results ----

