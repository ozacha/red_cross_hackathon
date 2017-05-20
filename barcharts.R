comp <- actuals[, .(partly_damaged_houses_true, 
                    completely_damaged_houses_true, 
                    total_damaged_houses_true, 
                    admin_L3_code)][predictions, on = .(admin_L3_code)]
comp[, perc_total_damaged_true := total_damaged_houses_true * 100 /
       sum(total_damaged_houses_true, na.rm = T)]
comp[, perc_partly_damaged_true := partly_damaged_houses_true * 100 /
       sum(partly_damaged_houses_true, na.rm = T)]
comp[, perc_total_damaged_true := total_damaged_houses_true * 100 /
       sum(total_damaged_houses_true, na.rm = T)]

comp[, perc_total_damaged_pred := total_damaged_houses_pred * 100 /
       sum(total_damaged_houses_pred, na.rm = T)]

ggplot(comp[!is.na(total_damaged_houses_true)],
       aes(x = factor(admin_L3_code, 
                      levels = admin_L3_code[order(-total_damaged_houses_true)]),
           y = total_damaged_houses_true)) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = function(x) area_names[x]) +
  theme(axis.text.x = element_text(angle = 90, size = 5, vjust = 0.5, hjust = 1)) +
  xlab("Region") + ylab("# total damaged houses (actuals)")
  
ggplot(comp[!is.na(partly_damaged_houses_true)],
       aes(x = factor(admin_L3_code, 
                      levels = admin_L3_code[order(-partly_damaged_houses_true)]),
           y = partly_damaged_houses_true)) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = function(x) area_names[x]) +
  theme(axis.text.x = element_text(angle = 90, size = 5, vjust = 0.5, hjust = 1)) +
  xlab("Region") + ylab("# partly damaged houses (actuals)")

ggplot(comp[!is.na(completely_damaged_houses_true)],
       aes(x = factor(admin_L3_code, 
                      levels = admin_L3_code[order(-completely_damaged_houses_true)]),
           y = completely_damaged_houses_true)) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = function(x) area_names[x]) +
  theme(axis.text.x = element_text(angle = 90, size = 5, vjust = 0.5, hjust = 1)) +
  xlab("Region") + ylab("# completely damaged houses (actuals)")

ggplot(comp[!is.na(total_damaged_houses_pred)][
  order(-total_damaged_houses_pred)][1:50],
       aes(x = factor(admin_L3_code, 
                      levels = admin_L3_code[order(-total_damaged_houses_pred)]),
           y = total_damaged_houses_pred)) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = function(x) area_names[x]) +
  theme(axis.text.x = element_text(angle = 90, size = 5, vjust = 0.5, hjust = 1)) +
  xlab("Region") + ylab("# total damaged houses (predicted)")

ggplot(comp[!is.na(partly_damaged_houses_pred)][
  order(-partly_damaged_houses_pred)][1:50],
       aes(x = factor(admin_L3_code, 
                      levels = admin_L3_code[order(-partly_damaged_houses_pred)]),
           y = partly_damaged_houses_pred)) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = function(x) area_names[x]) +
  theme(axis.text.x = element_text(angle = 90, size = 5, vjust = 0.5, hjust = 1)) +
  xlab("Region") + ylab("# partly damaged houses (predicted)")

ggplot(comp[!is.na(completely_damaged_houses_pred)][
  order(-completely_damaged_houses_pred)][1:50],
       aes(x = factor(admin_L3_code, 
                      levels = admin_L3_code[order(-completely_damaged_houses_pred)]),
           y = completely_damaged_houses_pred)) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = function(x) area_names[x]) +
  theme(axis.text.x = element_text(angle = 90, size = 5, vjust = 0.5, hjust = 1)) +
  xlab("Region") + ylab("# completely damaged houses (predicted)")
