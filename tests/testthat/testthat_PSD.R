## Data for tests
set.seed(56768)
df <- data.frame(tl=round(c(rnorm(100,mean=125,sd=15),
                            rnorm(50,mean=200,sd=25),
                            rnorm(20,mean=300,sd=40)),0),
                 species=factor(rep("Yellow Perch",170)))

set.seed(345234534)
dbt <- data.frame(species=factor(rep(c("Bluefin Tuna"),30)),
                  tl=round(rnorm(30,1900,300),0))
dbt$wt <- round(4.5e-05*dbt$tl^2.8+rnorm(30,0,6000),1)
dbg <- data.frame(species=factor(rep(c("Bluegill"),30)),
                  tl=round(rnorm(30,130,50),0))
dbg$wt <- round(4.23e-06*dbg$tl^3.316+rnorm(30,0,10),1)
dlb <- data.frame(species=factor(rep(c("Largemouth Bass"),30)),
                  tl=round(rnorm(30,350,60),0))
dlb$wt <- round(2.96e-06*dlb$tl^3.273+rnorm(30,0,60),1)
df <- rbind(dbt,dbg,dlb)

# read in external CSV file
ftmp <- system.file("extdata", "PSDWR_testdata.csv", package="FSA")
df2 <- read.csv(ftmp)
df2$species <- factor(df2$species)
df2$spec_code <- factor(df2$spec_code)
df2$GCATN <- factor(df2$GCATN,levels=c("substock","stock","quality","preferred",
                                       "memorable","trophy"))
df2bg <- droplevels(subset(df2,species=="Bluegill"))
df2lmb <- droplevels(subset(df2,species=="Largemouth Bass"))


## Test Messages ----
test_that("psdVal() messages",{
  ## bad species name
  expect_error(psdVal("Derek"),
               "There are no Gablehouse lengths in 'PSDlit'")
  expect_error(psdVal("bluegill"),
               "There are no Gablehouse lengths in 'PSDlit'")
  ## too many species name
  expect_error(psdVal(c("Bluegill","Yellow Perch")),
               "can have only one name")
  ## needed and bad group=
  expect_error(psdVal("Brown Trout"),
               "\"Brown Trout\" has Gabelhouse categories for these")
  expect_error(psdVal("Brown Trout",group="Derek"),
               "There is no \"Derek\" group for \"Brown Trout\"")
  ## bad units
  expect_error(psdVal("Bluegill",units="inches"),
               "should be one of")
  ## addLens and addNames don't match up
  expect_error(psdVal("Bluegill",addLens=7,addNames=c("Derek","Ogle")),
               "have different lengths")
  expect_error(psdVal("Bluegill",addLens=c(7,9),addNames="Derek"),
               "have different lengths")
  ## and addLens is also a Gabelhouse length
  expect_warning(psdVal("Bluegill",addLens=150),
                 "The following Gabelhouse length categories were removed")
})

test_that("psdCI() messages",{
  ## problems with proportions table
  # not obviously a proportions table
  #  expect_warning(psdCI(c(1,0,0,0),c(0.5,0.3,0.2,10),11))
  #  expect_warning(psdCI(c(1,0,0,0),c(5,3,2,10),20))
  # looks like proportions, but doesn't sum to 1
  expect_error(psdCI(c(1,0,0,0),c(0.5,0.3,0.1,0.08),20),
               "does not sum to 1")
  expect_error(psdCI(c(1,0,0,0),c(0.5,0.3,0.2,0.08),20),
               "does not sum to 1")
  # small n for table using multinomial distribution
  expect_warning(psdCI(c(0,0,0,1),c(0.5,0.3,0.1,0.1),20,method="multinomial"),
                 "CI coverage may be lower than 95%")
  
  ## problems with indicator vector
  ipsd <- c(0.130,0.491,0.253,0.123)
  n <- 445
  # all zeros
  expect_error(psdCI(c(0,0,0,0),ipsd,n),
               "cannot be all zeros")
  # all ones
  expect_error(psdCI(c(1,1,1,1),ipsd,n),
               "cannot be all ones")
  # wrong length of indvec
  expect_error(psdCI(c(1,0,0),ipsd,n),
               "must be the same")
  expect_error(psdCI(c(1,0,0,0,0),ipsd,n),
               "must be the same")
  
  ## ptbl not proportions
  ipsd <- c(5,4,3,3)
  n <- 300
  expect_warning(psdCI(c(1,0,0,0),ipsd,n),
                 "not a table of proportions")
  
  # bad args in conf.level
  ipsd <- c(0.130,0.491,0.253,0.123)
  n <- 445
  expect_error(psdCI(c(0,0,1,1),ipsd,n=n,conf.level=0),
               "must be between 0 and 1")
  expect_error(psdCI(c(0,0,1,1),ipsd,n=n,conf.level=1),
               "must be between 0 and 1")
  expect_error(psdCI(c(0,0,1,1),ipsd,n=n,conf.level="R"),
               "must be numeric")
  
  
})

test_that("psdCalc() messages",{
  ## species name does not exist in PSDlit
  expect_error(psdCalc(~tl,data=df,species="Slimy Sculpin"),
               "There are no Gablehouse lengths in 'PSDlit'")
  expect_error(psdCalc(~tl,data=df,species="Yellow perch"),
               "There are no Gablehouse lengths in 'PSDlit'")
  ## needed and bad group=
  expect_error(psdCalc(~tl,data=df,species="Brown Trout"),
               "\"Brown Trout\" has Gabelhouse categories for these")
  expect_error(psdCalc(~tl,data=df,species="Brown Trout",group="Derek"),
               "There is no \"Derek\" group for \"Brown Trout\"")
  expect_no_failure(psdCalc(~tl,data=df,species="Brown Trout",group="lotic"))  %>%
    suppressWarnings()
  
  ## get Gabelhouse lengths for Yellow Perch
  ghl <- psdVal("Yellow Perch")
  ## restrict data.frame to no fish
  tmp <- subset(df,tl<ghl["substock"])
  expect_error(psdCalc(~tl,data=tmp,species="Yellow Perch"),
               "does not contain any rows")
  ## restrict data.frame to sub-stock-length fish
  tmp <- subset(df,tl<ghl["stock"])
  expect_error(psdCalc(~tl,data=tmp,species="Yellow Perch"),
               "no stock-length fish in the sample")
  ## restrict data.frame to no >=quality fish
  tmp <- subset(df,tl<ghl["quality"])
  psdCalc(~tl,data=tmp,species="Yellow Perch") %>%
    expect_warning("No fish in larger than 'stock' categories") %>%
    suppressWarnings()
  
  ## bad formulae
  expect_error(psdCalc(tl,data=df,species="Yellow Perch"),
               "not found")
  expect_error(psdCalc(tl~species,data=df,species="Yellow Perch"),
               "Function only works with formulas with 1 variable")
  expect_error(psdCalc(~tl+species,data=df,species="Yellow Perch"),
               "Function only works with formulas with 1 variable")
  expect_error(psdCalc(~species,data=df,species="Yellow Perch"),
               "must be numeric")
  
  # testing confidence intervals
  expect_error(psdCalc(~tl,data=tmp,species="Yellow Perch",conf.level=0),
               "must be between 0 and 1")
  expect_error(psdCalc(~tl,data=tmp,species="Yellow Perch",conf.level=1),
               "must be between 0 and 1")
  expect_error(psdCalc(~tl,data=tmp,species="Yellow Perch",conf.level="R"),
               "must be numeric")

  # Testing when species name not given
  ## no species name given or addLens given
  expect_error(psdCalc(~tl,data=tmp),
               "Must include name in 'species' or lengths in 'addLens'")
  ## addLens must have at least two values
  expect_error(psdCalc(~tl,data=tmp,addLens=c("stock"=100)),
               "'addLens' must contain at least two length categories")
  ## addLens must have at least a stock and quality length
  expect_error(psdCalc(~tl,data=tmp,addLens=c("preferred"=100,"quality"=200)),
               "First category name must be 'stock'")
  expect_error(psdCalc(~tl,data=tmp,addLens=c("Stock"=100,"quality"=200)),
               "First category name must be 'stock'")
  expect_error(psdCalc(~tl,data=tmp,addLens=c(100,200),addNames=c("Stock","quality")),
               "First category name must be 'stock'")
  ## No names given
  expect_error(psdCalc(~tl,data=tmp,addLens=c(100,200,250)),
               "Category names must be defined in 'addLens'")
  ## lengths of addLens and addNames do not match
  expect_error(psdCalc(~tl,data=tmp,addLens=c(100,200),addNames=c("name1")),
               "'addLens' and 'addNames' cannot be different lengths")
  expect_error(psdCalc(~tl,data=tmp,addLens=c(100,200),
                       addNames=c("name1","name2","name3")),
               "'addLens' and 'addNames' cannot be different lengths")
})

test_that("psdPlot() messages",{
  ## get Gabelhouse lengths for Yellow Perch
  ghl <- psdVal("Yellow Perch")
  
  ## restrict data.frame to no fish
  tmp <- subset(df,tl<ghl["substock"])
  expect_error(psdPlot(~tl,data=tmp,species="Yellow Perch"),
               "does not contain any rows")
  ## restrict data.frame to no >=quality fish
  tmp <- subset(df,tl<ghl["quality"])
  ## set minimum length higher than stock length
  expect_error(psdPlot(~tl,data=df,species="Yellow Perch",
                       xlim=c(ghl["stock"]+10,300)),
               "Minimum length value in")
  
  ## bad formulae
  expect_error(psdPlot(tl,data=df,species="Yellow Perch"),
               "not found")
  expect_error(psdPlot(tl~species,data=df,species="Yellow Perch"),
               "Function only works with formulas with 1 variable.")
  expect_error(psdPlot(~tl+species,data=df,species="Yellow Perch"),
               "Function only works with formulas with 1 variable.")
  expect_error(psdPlot(~species,data=df,species="Yellow Perch"),
               "must be numeric")
})

test_that("psdAdd() messages",{
  ## bad units
  expect_error(psdAdd(tl~species,df,units="inches"),
               "should be one of")
  expect_error(psdAdd(df$tl,df$species,units="inches"),
               "should be one of")
  
  ## bad formulae
  expect_error(psdAdd(~tl,df),
               "one variable")
  expect_error(psdAdd(~species,df),
               "one variable")
  expect_error(psdAdd(tl~wt+species,df),
               "one variable")
  
  ## bad variable types
  expect_error(psdAdd(species~tl,df),
               "not numeric")
  expect_error(psdAdd(tl~wt,df),
               "only one factor")
  expect_error(psdAdd(df$species,df$tl),
               "numeric")
  expect_error(psdAdd(df$tl,df$wt),
               "factor")
  
  ## Bad species
  tmp <- df[df$species=="Bluefin Tuna",]
  expect_message(psdAdd(tl~species,data=tmp),
                 "Species in the data with no Gabelhouse")
  
  ## One species had all missing lengths
  tmp <- df
  tmp[df$species=="Bluegill","tl"] <- NA
  tmp <- tmp[tmp$species!="Bluefin Tuna",]
  expect_message(psdAdd(tl~species,tmp),
                 "were missing for")
})

test_that("tictactoe() errors and warnings",{
  ## objective values do not contain 2 values
  expect_error(tictactoe(predobj=70),
               "must contain two numbers")
  expect_error(tictactoe(predobj=71:75),
               "must contain two numbers")
  expect_error(tictactoe(predobj=NULL),
               "must be numeric")
  expect_error(tictactoe(predobj=NA),
               "must be numeric")
  expect_error(tictactoe(predobj=c(-5,70)),
               "must be between 0 and 100")
  expect_error(tictactoe(predobj=c(70,105)),
               "must be between 0 and 100")
  expect_error(tictactoe(predobj=c(-5,105)),
               "must be between 0 and 100")
  expect_error(tictactoe(predobj=c("A","B")),
               "must be numeric")
  expect_error(tictactoe(preyobj=70),
               "must contain two numbers")
  expect_error(tictactoe(preyobj=71:75),
               "must contain two numbers")
  expect_error(tictactoe(preyobj=NULL),
               "must be numeric")
  expect_error(tictactoe(preyobj=NA),
               "must be numeric")
  expect_error(tictactoe(preyobj=c(-5,70)),
               "must be between 0 and 100")
  expect_error(tictactoe(preyobj=c(70,105)),
               "must be between 0 and 100")
  expect_error(tictactoe(preyobj=c(-5,105)),
               "must be between 0 and 100")
  expect_error(tictactoe(preyobj=c("A","B")),
               "must be numeric")
})


## Test Output Types ----
test_that("psdVal() returns",{
  ## check values for yellow Perch
  tmp <- psdVal("Yellow Perch",incl.zero=FALSE)
  expect_equal(tmp,c(130,200,250,300,380),ignore_attr=TRUE)
  expect_equal(names(tmp),c("stock","quality","preferred","memorable","trophy"))
  tmp <- psdVal("Yellow Perch",incl.zero=FALSE,units="in")
  expect_equal(tmp,c(5,8,10,12,15),ignore_attr=TRUE)
  expect_equal(names(tmp),c("stock","quality","preferred","memorable","trophy"))
  tmp <- psdVal("Yellow Perch",units="in")
  expect_equal(tmp,c(0,5,8,10,12,15),ignore_attr=TRUE)
  expect_equal(names(tmp),c("substock","stock","quality","preferred",
                            "memorable","trophy" ))
  tmp <- psdVal("Yellow Perch",units="in",addLens=c(7,9))
  expect_equal(tmp,c(0,5,7,8,9,10,12,15),ignore_attr=TRUE)
  expect_equal(names(tmp),c("substock","stock","7","quality","9",
                            "preferred","memorable","trophy" ))
  tmp <- psdVal("Yellow Perch",units="in",addLens=c(7,9),
                addNames=c("minSlot","maxSlot"))
  expect_equal(tmp,c(0,5,7,8,9,10,12,15),ignore_attr=TRUE)
  expect_equal(names(tmp),c("substock","stock","minSlot","quality","maxSlot",
                            "preferred","memorable","trophy"))
  tmp <- psdVal("Yellow Perch",units="in",addLens=c(minSlot=7,maxSlot=9),
                addNames=c("minSlot","maxSlot"))
  expect_equal(tmp,c(0,5,7,8,9,10,12,15),ignore_attr=TRUE)
  expect_equal(names(tmp),c("substock","stock","minSlot","quality","maxSlot",
                            "preferred","memorable","trophy"))
  tmp <- psdVal("Yellow Perch")
  expect_equal(tmp,c(0,130,200,250,300,380),ignore_attr=TRUE)
  expect_equal(names(tmp),c("substock","stock","quality","preferred",
                            "memorable","trophy"))
  tmp <- psdVal("Yellow Perch",showJustSource=TRUE)
  expect_equal(class(tmp),"data.frame")
  expect_equal(ncol(tmp),2)
  expect_equal(nrow(tmp),1)
})

test_that("psdCI() returns",{
  n <- 997
  ipsd <- c(130,491,253,123)/n
  ## single binomial
  tmp <- psdCI(c(0,0,1,1),ipsd,n=n)
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),1)
  expect_equal(ncol(tmp),3)
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  tmp <- psdCI(c(1,0,0,0),ipsd,n=n,label="PSD S-Q")
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),1)
  expect_equal(ncol(tmp),3)
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  expect_equal(rownames(tmp),"PSD S-Q")
  ## single multinomial
  tmp <- psdCI(c(0,0,1,1),ipsd,n=n,method="multinomial")
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),1)
  expect_equal(ncol(tmp),3)
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  tmp <- psdCI(c(1,0,0,0),ipsd,n=n,method="multinomial",label="PSD S-Q")
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),1)
  expect_equal(ncol(tmp),3)
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  expect_equal(rownames(tmp),"PSD S-Q")
  ## Adjustment for not proportions
  ipsd <- c(130,491,253,123)
  n <- sum(ipsd)
  ipsd2 <- ipsd/n
  tmp <- suppressWarnings(psdCI(c(0,0,1,1),ipsd,n=n))
  tmp2 <- psdCI(c(0,0,1,1),ipsd2,n=n)
  expect_equal(tmp,tmp2)
  tmp <- suppressWarnings(psdCI(c(0,0,1,1),ipsd,n=n,method="multinomial"))
  tmp2 <- psdCI(c(0,0,1,1),ipsd2,n=n,method="multinomial")
  expect_equal(tmp,tmp2)
  ## Adjustment for a PSD of 0 or 1
  ipsd <- c(1,0,0,0)
  n <- 455
  tmp <- psdCI(c(1,1,0,0),ipsd,n=n)
  expect_equal(tmp,matrix(c(100,NA,NA),nrow=1),ignore_attr=TRUE)
  ipsd <- c(0,0,0,1)
  n <- 455
  tmp <- psdCI(c(1,1,0,0),ipsd,n=n)
  expect_equal(tmp,matrix(c(0,NA,NA),nrow=1),ignore_attr=TRUE)
})  

test_that("psdCalc() returns",{
  ## All values
  tmp <- suppressWarnings(psdCalc(~tl,data=df,species="Yellow Perch"))
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),8)
  expect_equal(ncol(tmp),3)
  expect_equal(rownames(tmp),c("PSD-Q","PSD-P","PSD-M","PSD-T","PSD S-Q",
                               "PSD Q-P","PSD P-M","PSD M-T"))
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  ## Traditional values
  tmp <- suppressWarnings(psdCalc(~tl,data=df,species="Yellow Perch",
                                  what="traditional"))
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),4)
  expect_equal(ncol(tmp),3)
  expect_equal(rownames(tmp),c("PSD-Q","PSD-P","PSD-M","PSD-T"))
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  tmp <- suppressWarnings(psdCalc(~tl,data=df,species="Yellow Perch"))
  ## Incremental values
  tmp <- suppressWarnings(psdCalc(~tl,data=df,species="Yellow Perch",
                                  what="incremental"))
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),4)
  expect_equal(ncol(tmp),3)
  expect_equal(rownames(tmp),c("PSD S-Q","PSD Q-P","PSD P-M","PSD M-T"))
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  ## All values, but don't drop 0s
  tmp <- suppressWarnings(psdCalc(~tl,data=df,species="Yellow Perch",
                                  drop0Est=FALSE))
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),8)
  expect_equal(ncol(tmp),3)
  expect_equal(rownames(tmp),c("PSD-Q","PSD-P","PSD-M","PSD-T","PSD S-Q",
                               "PSD Q-P","PSD P-M","PSD M-T"))
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  ## All values, with some additional lengths
  tmp <- suppressWarnings(psdCalc(~tl,data=df,species="Yellow Perch",
                                  addLens=225,addNames="Derek"))
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),10)
  expect_equal(ncol(tmp),3)
  expect_equal(rownames(tmp),c("PSD-Q","PSD-Derek","PSD-P","PSD-M","PSD-T",
                               "PSD S-Q","PSD Q-Derek","PSD Derek-P",
                               "PSD P-M","PSD M-T"))
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  ## All values, with some additional lengths but no names
  tmp <- suppressWarnings(psdCalc(~tl,data=df,species="Yellow Perch",
                                  addLens=c(225,245),drop0Est=FALSE))
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),12)
  expect_equal(ncol(tmp),3)
  expect_equal(rownames(tmp),c("PSD-Q","PSD-225","PSD-245","PSD-P","PSD-M",
                               "PSD-T","PSD S-Q","PSD Q-225","PSD 225-245",
                               "PSD 245-P","PSD P-M","PSD M-T"))
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  ## Just the additional values
  tmp <- suppressWarnings(psdCalc(~tl,data=df,species="Yellow Perch",
                                  addLens=c(225,245),drop0Est=FALSE,
                                  justAdds=TRUE))
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),5)
  expect_equal(ncol(tmp),3)
  expect_equal(rownames(tmp),c("PSD-225","PSD-245","PSD Q-225",
                               "PSD 225-245","PSD 245-P"))
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  ## All values, but df only has values greater than stock values
  df1 <- droplevels(subset(df,tl>=130))
  tmp <- suppressWarnings(psdCalc(~tl,data=df1,species="Yellow Perch"))
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),8)
  expect_equal(ncol(tmp),3)
  expect_equal(rownames(tmp),c("PSD-Q","PSD-P","PSD-M","PSD-T","PSD S-Q",
                               "PSD Q-P","PSD P-M","PSD M-T"))
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  ## All values, but df only has values greater than quality values
  df1 <- droplevels(subset(df,tl>=200))
  tmp <- suppressWarnings(psdCalc(~tl,data=df1,species="Yellow Perch"))
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),7)
  expect_equal(ncol(tmp),3)
  expect_equal(rownames(tmp),c("PSD-Q","PSD-P","PSD-M","PSD-T",
                               "PSD Q-P","PSD P-M","PSD M-T"))
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  ## All values, but df only has values greater than memorable value
  df1 <- droplevels(subset(df,tl>=300))
  tmp <- suppressWarnings(psdCalc(~tl,data=df1,species="Yellow Perch"))
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),5)
  expect_equal(ncol(tmp),3)
  expect_equal(rownames(tmp),c("PSD-Q","PSD-P","PSD-M","PSD-T","PSD M-T"))
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  
  ## Pretend like no species is given
  tmp <- suppressWarnings(psdCalc(~tl,data=df,
                                  addLens=c("stock"=130,"quality"=200,"preferred"=250,
                                            "memorable"=300,"trophy"=380)))
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),8)
  expect_equal(ncol(tmp),3)
  expect_equal(rownames(tmp),c("PSD-Q","PSD-P","PSD-M","PSD-T","PSD S-Q",
                               "PSD Q-P","PSD P-M","PSD M-T"))
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
  
  tmp <- suppressWarnings(psdCalc(~tl,data=df,
                                  addLens=c("stock"=130,"name1"=200,"name2"=250)))
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),4)
  expect_equal(ncol(tmp),3)
  expect_equal(rownames(tmp),c("PSD-name1","PSD-name2","PSD S-name1","PSD name1-name2"))
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))

  tmp <- suppressWarnings(psdCalc(~tl,data=df,
                                  addLens=c("stock"=130,"name1"=200)))
  expect_equal(class(tmp),c("matrix","array"))
  expect_equal(mode(tmp),"numeric")
  expect_equal(nrow(tmp),2)
  expect_equal(ncol(tmp),3)
  expect_equal(rownames(tmp),c("PSD-name1","PSD S-name1"))
  expect_equal(colnames(tmp),c("Estimate","95% LCI","95% UCI"))
})

test_that("psdAdd() returns",{
  tmp <- df
  tmp$PSD <- suppressMessages(psdAdd(tl~species,data=tmp))
  expect_equal(ncol(tmp),4)
  expect_true(is.factor(tmp$PSD))
  tmp$PSD <- suppressMessages(psdAdd(tl~species,data=tmp,use.names=FALSE))
  expect_equal(ncol(tmp),4)
  expect_true(is.numeric(tmp$PSD))
})


## Validate Results ----
test_that("Does psdAdd() create correct Gabelhouse categories?",{
  suppressMessages(df2$gcatn <- psdAdd(tl~species,data=df2))
  expect_equal(df2$gcatn,df2$GCATN)
})

test_that("Does psdAdd() properly handle NA in species?",{
  ## Makes sure NAs are in proper position and by extension correct number
  # Just NAs for species only one other species
  testdf <- data.frame(TL=c(400,90,250,130,50),
                       Spp=c("White Crappie",NA,"White Crappie",
                             "White Crappie","White Crappie"))
  suppressMessages(gcat <- psdAdd(TL~Spp,data=testdf,drop.levels=TRUE))
  expect_equal(which(is.na(testdf$TL) | is.na(testdf$Spp)),
                  which(is.na(gcat)))
  
  # Just NAs for species only multiple other species
  testdf <- data.frame(TL=c(400,90,250,130,50),
                       Spp=c("White Crappie",NA,"White Crappie",
                             "White Crappie","Black Crappie"))
  suppressMessages(gcat <- psdAdd(TL~Spp,data=testdf,drop.levels=TRUE))
  expect_equal(which(is.na(testdf$TL) | is.na(testdf$Spp)),
                    which(is.na(gcat)))

  # Just NAs for species, but with a species w/o Gabelhouse lengths
  testdf <- data.frame(TL=c(400,90,250,NA,50),
                       Spp=c("White Crappie",NA,"badSpp",
                             "White Crappie","Black Crappie"))
  suppressMessages(gcat <- psdAdd(TL~Spp,data=testdf,drop.levels=TRUE))
  expect_equal(which(is.na(testdf$TL) | is.na(testdf$Spp) | testdf$Spp=="badSpp"),
                    which(is.na(gcat)))
  
  # NAs for length and species
  testdf <- data.frame(TL=c(400,90,250,NA,50),
                       Spp=c("White Crappie",NA,"White Crappie",
                             "White Crappie","Black Crappie"))
  suppressMessages(gcat <- psdAdd(TL~Spp,data=testdf,drop.levels=TRUE))
  expect_equal(which(is.na(testdf$TL) | is.na(testdf$Spp)),
                    which(is.na(gcat)))

})

test_that("Does psdCalc() compute correct PSD values?",{
  suppressWarnings(bgres <- psdCalc(~tl,data=df2bg,species="Bluegill"))
  expect_equal(bgres[,"Estimate"],c(80,60,40,20,20,20,20,20),ignore_attr=TRUE)
  suppressWarnings(lmbres <- psdCalc(~tl,data=df2lmb,species="Largemouth Bass"))
  expect_equal(lmbres[,"Estimate"],c(60,30,10,40,30,20,10),ignore_attr=TRUE)
  ## pretend like no species is given (but using bluegill results)
  suppressWarnings(bgres <- psdCalc(~tl,data=df2bg,
                                    addLens=c("stock"=80,"quality"=150,
                                              "preferred"=200,"memorable"=250,
                                              "trophy"=300)))
  expect_equal(bgres[,"Estimate"],c(80,60,40,20,20,20,20,20),ignore_attr=TRUE)
})

#test_that("Does psdCalc() work with a tibble?",{
#  tmp <- tibble::as_tibble(df2bg)
#  suppressWarnings(bgres <- psdCalc(~tl,data=df2bg,species="Bluegill"))
#  suppressWarnings(bgres2 <- psdCalc(~tl,data=tmp,species="Bluegill"))
#  expect_equal(bgres,bgres2)
#})

test_that("Does psdCI results match Brenden et al. (2008) results",{
  ## proportions table from Brenden et al. (2008)
  ipsd <- c(0.130,0.491,0.253,0.123)
  n <- 445
  
  ## results from Brendent et al. (2008) ... Table 2
  bpsd <- cbind(c(13,49,25,12,87,38),
                c(9,42,20,8,82,31),
                c(17,56,31,17,91,44))
  colnames(bpsd) <- c("Estimate","95% LCI","95% UCI")
  rownames(bpsd) <- c("PSD S-Q","PSD Q-P","PSD P-M","PSD M-T","PSD","PSD-P")
  
  ## psdCI calculations
  imat <- matrix(c(1,0,0,0,
                   0,1,0,0,
                   0,0,1,0,
                   0,0,0,1,
                   0,1,1,1,
                   0,0,1,1),nrow=6,byrow=TRUE)
  rownames(imat) <- rownames(bpsd)
  mcis <- t(apply(imat,MARGIN=1,FUN=psdCI,ptbl=ipsd,n=n,method="multinomial"))
  colnames(mcis) <- c("Estimate","95% LCI","95% UCI")
  diff <- mcis-bpsd
  # Brenden's results were rounded, thus all should be within 0.5
  expect_true(all(abs(diff)<=0.5))
})

test_that("Does psdCI results match Brenden et al. (2008) results",{
  ## Setup sample with known PSD values
  brks <- psdVal("Yellow Perch")
  freq <- c(110,75,50,35,20,10)
  df3 <- data.frame(tl=rep(brks,freq)+sample(1:45,300,replace=TRUE),
                    species=factor(rep("Yellow Perch",300)))
  ## Get known PSD values
  psdXYs <- prop.table(freq[-1])*100
  psdXs <- rcumsum(psdXYs)[-1]
  psdXYs <- psdXYs[-length(psdXYs)]
  ## Get psdCalc results
  suppressWarnings(
    resXY <- psdCalc(~tl,data=df3,species="Yellow Perch",what="incremental",
                     digits=getOption("digits")))
  suppressWarnings(
    resX <- psdCalc(~tl,data=df3,species="Yellow Perch",what="traditional",
                    digits=getOption("digits")))
  ## Are lengths what you would expect
  expect_equal(nrow(resXY),4)
  expect_equal(nrow(resX),4)
  ## Are values the same
  diffs <- round(resXY[,"Estimate"]-psdXYs,7)
  expect_equal(diffs,rep(0,length(diffs)),ignore_attr=TRUE)
  diffs <- round(resX[,"Estimate"]-psdXs,7)
  expect_equal(diffs,rep(0,length(diffs)),ignore_attr=TRUE)
  
  ## Do things still work if all sub-stock fish are removed
  tmp <- droplevels(subset(df3,tl>=brks["stock"]))
  suppressWarnings(
    resXY <- psdCalc(~tl,data=tmp,species="Yellow Perch",what="incremental",
                     digits=getOption("digits")))
  suppressWarnings(
    resX <- psdCalc(~tl,data=tmp,species="Yellow Perch",what="traditional",
                    digits=getOption("digits")))
  expect_equal(nrow(resXY),4)
  expect_equal(nrow(resX),4)
  ## Are values the same
  diffs <- round(resXY[,"Estimate"]-psdXYs,7)
  expect_equal(diffs,rep(0,length(diffs)),ignore_attr=TRUE)
  diffs <- round(resX[,"Estimate"]-psdXs,7)
  expect_equal(diffs,rep(0,length(diffs)),ignore_attr=TRUE)
  
  ## Do things still work if all sub-stock and stock fish are removed  
  psdXYs <- prop.table(freq[-c(1:2)])*100
  psdXs <- rcumsum(psdXYs)[-1]
  psdXYs <- psdXYs[-length(psdXYs)]
  
  tmp <- droplevels(subset(df3,tl>=brks["quality"]))
  suppressWarnings(
    resXY <- psdCalc(~tl,data=tmp,species="Yellow Perch",what="incremental",
                     digits=getOption("digits")))
  suppressWarnings(
    resX <- psdCalc(~tl,data=tmp,species="Yellow Perch",what="traditional",
                    digits=getOption("digits")))
  expect_equal(nrow(resXY),3)  # no S-Q row
  expect_equal(nrow(resX),4)   # all should be there
  ## Are values the same
  diffs <- round(resXY[,"Estimate"]-psdXYs,7)
  expect_equal(diffs,rep(0,length(diffs)),ignore_attr=TRUE)
  diffs <- round(resX[-1,"Estimate"]-psdXs,7)
  expect_equal(diffs,rep(0,length(diffs)),ignore_attr=TRUE)
  
  ## Do things still work if all trophy fish are removed  
  psdXYs <- prop.table(freq[-c(1,length(freq))])*100
  psdXs <- rcumsum(psdXYs)[-1]
  
  tmp <- droplevels(subset(df3,tl<brks["trophy"]))
  suppressWarnings(
    resXY <- psdCalc(~tl,data=tmp,species="Yellow Perch",what="incremental",
                     digits=getOption("digits")))
  suppressWarnings(
    resX <- psdCalc(~tl,data=tmp,species="Yellow Perch",what="traditional",
                    digits=getOption("digits")))
  expect_equal(nrow(resXY),4)  # no T- row
  expect_equal(nrow(resX),3)   # no T row
  ## Are values the same
  diffs <- round(resXY[,"Estimate"]-psdXYs,7)
  expect_equal(diffs,rep(0,length(diffs)),ignore_attr=TRUE)
  diffs <- round(resX[,"Estimate"]-psdXs,7)
  expect_equal(diffs,rep(0,length(diffs)),ignore_attr=TRUE)
})

test_that("Does manual calculation after psdAdd() equal psdCalc() results?",{
  ## get psdCalc results for LMB and BG .. ultimately compare to psdDataPrep results
  suppressWarnings(
    psdBG <- psdCalc(~tl,data=droplevels(subset(df,species=="Bluegill")),
                     species="Bluegill",digits=getOption("digits")))
  suppressWarnings(
    psdLMB <- psdCalc(~tl,
                      data=droplevels(subset(df,species=="Largemouth Bass")),
                      species="Largemouth Bass",digits=getOption("digits")))
  
  ## apply psdAdd
  suppressMessages(df$PSDcat <- psdAdd(tl~species,df))
  # remove substock and other fish
  tmp <- droplevels(subset(df,species %in% c("Bluegill","Largemouth Bass")))
  tmp <- droplevels(subset(tmp,PSDcat!="substock"))
  res <- prop.table(xtabs(~species+PSDcat,data=tmp),margin=1)*100
  ## do PSD X-Y results match for two species
  ## Are values the same
  diffs <- round(res["Bluegill",1:3]-psdBG[3:5,"Estimate"],7)
  expect_equal(diffs,rep(0,length(diffs)),ignore_attr=TRUE)
  diffs <- round(res["Largemouth Bass",1:3]-psdLMB[3:5,"Estimate"],7)
  expect_equal(diffs,rep(0,length(diffs)),ignore_attr=TRUE)
})
