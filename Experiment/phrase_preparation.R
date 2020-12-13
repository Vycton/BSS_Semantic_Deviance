require(tidyr)
require(dplyr)

dat <- read.csv("scores.csv")
freqdat <- read.csv("unigram_freq.csv")

low_score <- 0.9
high_score <- 0.1

names(dat) <- c("phrase", "score")
dat <- subset(dat, subset =  score <= high_score | score >= low_score)

dat$deviance <- factor("low")
levels(dat$deviance) <- c("low", "high")
dat$deviance[dat$score <= high_score] <- "high"

dat <- separate(data = dat, col = phrase, into = c("adj", "noun"), sep = " ")

dat$noun_len <- nchar(dat$noun)
dat$adj_len <- nchar(dat$adj)

# for adjectives such as on-line, which are not hyphenated in the frequency data. 
# There are only 69 of these, so feel free to check them.
dat$adj <- stringr::str_replace(dat$adj, "-", "")

dat$adj_freq <- lapply(dat, function(x) freqdat$count[match(x, freqdat$word)])$adj
dat$noun_freq <- lapply(dat, function(x) freqdat$count[match(x, freqdat$word)])$noun
dat <- subset(dat, subset = !is.na(adj_freq) & !is.na(noun_freq))
dat$adj_freq_bin <-   round(log(dat$adj_freq, 2))
dat$noun_freq_bin <-  round(log(dat$noun_freq, 2))

#boxplot(phrase_len ~ deviance, data=dat) # means look different
#t.test(phrase_len ~ deviance, data=dat)  # means definitely different

subset.data <- function(data){
  vals <- unique(data[c("adj_len", "noun_len", "adj_freq_bin", "noun_freq_bin")])
  
  total_steps <- nrow(vals)
  print(paste("Total steps:", total_steps))
  step <- 0
  
  for(rowname in rownames(vals)){
    
    a_len <- vals[rowname, "adj_len"]
    n_len <- vals[rowname, "noun_len"]
    adjf <- vals[rowname, "adj_freq_bin"]
    nounf <- vals[rowname, "noun_freq_bin"]
    
    high <- subset(data, subset = adj_len == a_len & noun_len == n_len & 
                                  adj_freq_bin == adjf & noun_freq_bin == nounf 
                                  & deviance == "high")
    low <-  subset(data, subset = adj_len == a_len & noun_len == n_len & 
                                  adj_freq_bin == adjf & noun_freq_bin == nounf 
                                  & deviance == "low")
                
    i_min <- min(c(nrow(high), nrow(low)))
    
    h_exclude <- high[sample(rownames(high), nrow(high) - i_min), ]
    l_exclude <- low[sample(rownames(low),  nrow(low) - i_min), ]
    
    data <- anti_join(data, h_exclude, by=names(data))
    data <- anti_join(data, l_exclude, by=names(data))
    
    oldstep <- step
    step <- oldstep + 1
    if( floor((step/total_steps)*100) > floor((oldstep/total_steps)*100)){
      print(paste(step, "/", total_steps, " - ", 
                  floor((step/total_steps)*100), "%",
                  " Rows remaining: ", nrow(data), sep=""))
    }
  }
  
  data
}

dat.filt <- subset.data(dat)
nrow(dat.filt)
write.csv(dat.filt, "filtered_phrases.csv")

low.filt <- subset(dat.filt, subset = deviance == "low")
high.filt <- subset(dat.filt, subset = deviance == "high")

write.csv(low.filt, "low_deviance_phrases.csv")
write.csv(high.filt, "high_deviance_phrases.csv")


