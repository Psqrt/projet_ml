# setting default parameters for crosstables
fun_crosstable = function(df, var1, var2){
  # df: dataframe containing both columns to cross
  # var1, var2: columns to cross together.
  CrossTable(df[, var1], df[, var2],
             prop.r = T,
             prop.c = F,
             prop.t = F,
             prop.chisq = F,
             dnn = c(var1, var2))
}