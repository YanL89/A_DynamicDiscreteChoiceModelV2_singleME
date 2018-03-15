rm(list=ls())
#-------------------------set work directory---------------------------
setwd("C:/Users/Yan/Dynamic Modeling/dynamic discrete choice model_single ME")

#-------------------------load source files----------------------------
source("models.R")
source("dynAR1.R")
source("dynData.R")
source("dynUtils.R")

source("args.R")
source("misc.R")
source("create_X.R")
source("LL.R")
source("SD.R")
source("deriv.R")

source("logit.R")

source("dyn2logitV2.R")

source("DynSimAR.R")

#----------------------define model specification-----------------------
spec = list(
  
  #load data
  D = "Example_DataFiles/dyn",
  Time = "Example_DataFiles/time.txt",
  Global = "Example_DataFiles/global.txt",
  First = "Example_DataFiles/first.txt",
  choices = "Example_DataFiles/choice15.txt",
  
  #define independent attributes
  payoff_alt = c(),
  payoff_time = c("Vehicles"),
  payoff_global = c("Workers"),
  generic = list(),
  specific = list(c("VehPrice.1", "GasPrice.1"), c("ASC", "VehPrice.2"), c("ASC", "VehPrice.3", "range.3", "ElePrice.3")), # put variables here in one vector per alternative
  
  #restructure data  
  modifyD = function(D,Time,Global,Z,t){
    allTime = Time_select_vars(Time, NULL, t, all = TRUE)  
    Dyan = cbind(D[[t]], Global, allTime)
    return(Dyan)
  },
  
  # put dynamic variables here for AR(1) simulation
  dynvar = list("GasPrice.1"),
  # put coefficients here, in a vector. One set of coefficients for each AR(1) variable
  ## c(alpha, eta, sigma *** not sigma^2)
  dynpars = list(c(0.9861, 0.0465, 0.0532)),
  B = 10,  #number of simulations to generate dynamic variable
  
  #set basic parameters
  SD = "hessian",
  ASC = FALSE, 
  nTime = 15,  #actual time periods = total time T - look ahead time period L
  nLook = 3,  #look ahead time period L
  stopAlt = c(1,2,3), # HERE, if you have more than one alternative 
  # that halts the decision process, put them in a vector 
  # like stopAlt = c(1,2,10) if alt 1, 2 and 10 are stopping alternatives
  outTime = 7 #time periods that halts the decision process
  #i.e., outTime = 0 means never be out-of-market
  #outTime >= nTime means once be out-of-market the decision maker will never return
)

#-----------------------check model specification------------------------
spec = checkFillDynSpec(spec)

#----------------------------model estimation----------------------------
modelFns = dynAR1
D = NULL
Sys.time()
Mar = model(modelFns, spec, D)
Sys.time()
Mar

#--------------------------model application------------------------------
#ApplyMar = dynApply(Mar, spec)
#ApplyMar = round(100*ApplyMar) / 100
