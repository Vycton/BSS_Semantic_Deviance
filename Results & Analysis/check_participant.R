require(stringr)
require(tidyr)
require(dplyr)

folder <- paste("Data-anonymous", .Platform$file.sep, sep = "")
i <- 1

responses <- read.csv(paste(folder, i, "_data.csv", sep=""))
names(responses) <- c("round", "recalled")
data <- read.csv(paste(folder, "subject-", i, "-an.csv", sep=""))

phrase_list <- data$phrases[1]
phrase_list <- substr(phrase_list, 3, nchar(phrase_list)-2)
phrase_list <- str_split(phrase_list, coll("], ["))

phrases <- as.data.frame(phrase_list[[1]])
names(phrases) <- "string"
phrases$string <- substr(phrases$string, 2, nchar(phrases$string) -1)
phrases <- separate(data = phrases, col = string, into = c("ID", "adjective", 
                                                           "noun", "score", "deviance", "noun_len", "adj_len", 
                                                           "adj_freq", "noun_freq", "adj_freq_bin", "noun_freq_bin"), 
                    sep = "', '")
an_phrases <- paste(phrases$adjective, phrases$noun)

recalled_mat <- str_split(responses$recalled, coll(";"))
rec_phrases <- numeric(3)

for(j in 1:3){
  rec_phrases[j] <- sum(unique(recalled_mat[[j]]) %in% an_phrases)
}

rec_phrases
recalled_mat
an_phrases
