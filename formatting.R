require(stringr)
require(tidyr)
require(dplyr)
require(chron)

#Setup dataframe
results <- data.frame(matrix(nrow = 12, ncol = 18))
names(results) <- c("t1_pairs", "t2_pairs", "t3_pairs",
                    "t1_single", "t2_single", "t3_single",
                    "t1_err_pairs", "t2_err_pairs", "t3_err_pairs",
                    "t1_err_single", "t2_err_single", "t3_err_single",
                    "deviance", "age", "gender", "native", "education", "time")

folder <- paste("Data-anonymous", .Platform$file.sep, sep = "")

#For each participant
for (i in 1:12){
  #Import transcribed responses
  responses <- read.csv(paste(folder, i, "_data.csv", sep=""))
  names(responses) <- c("round", "recalled")
  
  #Import OpenSesame data
  data <- read.csv(paste(folder, "subject-", i, "-an.csv", sep=""))
  
  #Get Python-form list string of phrase data
  phrase_list <- data$phrases[1]
  phrase_list <- substr(phrase_list, 3, nchar(phrase_list)-2)
  phrase_list <- str_split(phrase_list, coll("], ["))
  
  #Reconstruct dataframe from very convenient OpenSesame format I really like OpenSesame we should force all scientists to use it
  phrases <- as.data.frame(phrase_list[[1]])
  names(phrases) <- "string"
  phrases$string <- substr(phrases$string, 2, nchar(phrases$string) -1)
  phrases <- separate(data = phrases, col = string,
                      into = c("ID", "adjective", "noun", "score", "deviance",
                               "noun_len", "adj_len", "adj_freq", "noun_freq",
                               "adj_freq_bin", "noun_freq_bin"),
                      sep = "', '")
  
  #Get loose phrases/words for comparison
  an_phrases <- paste(phrases$adjective, phrases$noun)
  an_words <- c(phrases$adjective, phrases$noun)
  
  #Parse recalled phrases/single words and put them into separate matrices
  recalled_phrases <- str_split(responses$recalled, coll(";"))
  recalled_words <- str_split(responses$recalled, "(\\s|;)")
  
  #Initialize vectors that will hold the number of recalled phrases/words per trial
  rec_phrases <- numeric(3)
  rec_words <- numeric(3)
  err_phrases <- numeric(3)
  err_words <- numeric(3)
  
  #Count number of recalled phrases
  for(j in 1:3){
    matched_pairs <- intersect(unique(recalled_phrases[[j]]), an_phrases)
    matched_words <- intersect(unique(recalled_words[[j]]), an_words)

    rec_phrases[j] <- length(matched_pairs)
    rec_words[j] <- length(matched_words)
    
    # Todo: recalled single words should probably not be treated as word pairs
    err_phrases[j] <- length(recalled_phrases[[j]]) - length(matched_pairs)
    err_words[j] <- length(recalled_words[[j]]) - length(matched_words)
  }
  
  # Get time in hours after 9AM
  time <- times(str_split(data$datetime[1], " ")[[1]][5])
  time <- hours(time) + minutes(time)/60 - 9
  time <- round(time, 1)
  
  
  #Insert number of recalled phrases along with other data
  results[i,] <-  c(rec_phrases, rec_words, err_phrases, err_words, phrases$deviance[1], data$p_age[1],
                    data$p_gender[1], data$p_language[1], data$p_education[1],
                    time)
}

#Set correct types.
results <- transform(results,
                     t1_pairs = as.numeric(t1_pairs),
                     t2_pairs = as.numeric(t2_pairs),
                     t3_pairs = as.numeric(t3_pairs),
                     t1_single = as.numeric(t1_single),
                     t2_single = as.numeric(t2_single),
                     t3_single = as.numeric(t3_single),
                     t1_err_pairs = as.numeric(t1_err_pairs),
                     t2_err_pairs = as.numeric(t2_err_pairs),
                     t3_err_pairs = as.numeric(t3_err_pairs),
                     t1_err_single = as.numeric(t1_err_single),
                     t2_err_single = as.numeric(t2_err_single),
                     t3_err_single = as.numeric(t3_err_single),
                     deviance = factor(deviance),
                     age = as.numeric(age),
                     gender = factor(gender),
                     native = factor(native),
                     education = factor(education),
                     time = as.numeric(time))

#Save file
save(results, file="deviance_results.rData")
#write.csv(results, "deviance_results.csv")
