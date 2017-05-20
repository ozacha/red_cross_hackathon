library(data.table)
library(ggplot2)

require("rgdal")
require("maptools")
require("ggplot2")
require("plyr")

philmap <- readOGR(dsn = "../QGIS visualization/PH_municipalities", 
                   layer = "PH_municipalities")
philmap@data$id <- rownames(philmap@data)
philmap.points <- data.table(fortify(philmap, region = "Mun_Code"))
philmap.dt <- data.table(philmap@data)
philmap.dt <- philmap.dt[philmap.points, on = .(Mun_Code = id)]
philmap.dt[, admin_L3_code := as.character(Mun_Code)]

predictions <- fread("../predictions_Nina.csv")
actuals <- fread("../actuals_Nina.csv")
dt <- data.table(read.csv("../aa_merged_nina_full.csv",
                          sep = "", dec = ",",
                          stringsAsFactors = F))

final <- dt[philmap.dt, on = .(admin_L3_code)]
final <- predictions[final, on = .(admin_L3_code)]
final <- actuals[final, on = .(admin_L3_code)]
final[, perc_damaged_houses_pred := total_damaged_houses_pred / n_households]
final[, perc_damaged_houses_true := total_damaged_houses_true / n_households]


area_names <- predictions$admin_L3_name
names(area_names) <- predictions$admin_L3_code

# ggplot(philmap.dt) + 
#   aes(long, lat, group = group, fill = Mun_Name) + 
#   geom_polygon() +
#   geom_path(color = "white") +
#   coord_quickmap() +
#   scale_fill_brewer("philmap Ecoregion") +
#   guides(fill = F, color = F)
# 
# ggplot(final) + 
#   aes(long, lat, group = group, fill = poverty_perc) + 
#   geom_polygon() +
#   coord_quickmap() +
#   # coord_cartesian(xlim = c(120, 121), ylim = c(10, 11)) +
#   scale_fill_continuous("philmap Ecoregion") +
#   guides(fill = F, color = F)
