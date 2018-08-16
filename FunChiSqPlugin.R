require("FunChisq")

p_value <- 0.06;
libs <- c("Hmisc");
lapply(libs, require, character.only=T);

input <- function(inputfile) {
  pc <<- read.csv(inputfile, header = TRUE);
}


run <- function() {
  cn <<- colnames(pc);
  cn <<- cn[2:length(cn)];
  #pc <<- pc[,-1];
  #pc <<- pc[-1,];
  pc <<- apply(pc, 1, as.numeric);
  pc <<- t(pc);

  print(pc[1,1])
  print(as.numeric(pc[1,1]))
  print(pc[1,2])
  print(pc[2,1])
  # First, determine how many different quanta there are at each point
  quanta <- vector(mode="integer", length=length(cn))

  for (j in 1:length(cn)) {
     maxquantum <- 1
     for (i in 1:nrow(pc)) {
        quantum <- as.numeric(pc[i, j])
        if (quantum > maxquantum) {
           maxquantum <- quantum
        }
     }
     quanta[j] <- maxquantum
  }

  # Assuming at this point pc is a matrix
  # Already has been quantized
  relations <<- matrix(0.0, nrow = length(cn), ncol = length(cn))
  #pvalues <<- matrix(, nrow = length(cn), ncol = length(cn))  

  for (i in 1:nrow(relations)) {
     for (j in 1:ncol(relations)) {
        # Determine FunChiSq relation between node i and node j
        # Assemble contingency matrix
        # Dimension will be the number of quanta for node i X number of quanta for node j
        contingency <- matrix(0, nrow=quanta[i], ncol=quanta[j])
        for (k in 1:nrow(pc)) {
           quantumI <- as.numeric(pc[k, i])
           quantumJ <- as.numeric(pc[k, j])
           contingency[quantumI, quantumJ] <- contingency[quantumI, quantumJ] + 1
        }        
        res <- fun.chisq.test(contingency)
        # Compute relation using FunChiSq
        if (as.numeric(res$p.value) < p_value) {
           relations[i, j] <<- as.numeric(res$statistic)
        }
        else if (i == j) {
           print("************************************************")
           print(contingency)
           print(cn[i])
           print(as.numeric(res$statistic))
           print(as.numeric(res$p.value))
           print("************************************************")
        }
        #pvalues[i, j] <<- as.numeric(res$p.value)
     }
  }
}

output <- function(outputfile) {
   write.table(relations, file=outputfile, sep=",", append=FALSE, row.names=unlist(cn), col.names=unlist(cn), na="");
   #write.table(relations, file=paste(outputfile, "csv", sep="."), sep=",", append=FALSE, row.names=unlist(cn), col.names=unlist(cn), na="");
   #write.table(pvalues, file=paste(outputfile, "pvalues.csv", sep="."), sep=",", append=FALSE, row.names=unlist(cn), col.names=unlist(cn), na="");
}


