# The model-management.R file is intended to be a scratchpad for doing things
# like defining, submitting, tagging, etc. your models. There is no need to keep
# a "record in code" of these activities because they can all be reconstructed
# later via functions like `run_log()`, as demonstrated in `model-summary.Rmd`
#
# The `Model Management Demo` (rendered from the `model-management-demo.Rmd`
# file) shows code for a range of these activities at different stages in the
# modeling process. It exists purely for reference; the intent is _not_ for you
# to replicate the full narrative.
# https://ghe.metrumrg.com/pages/example-projects/bbr-nonmem-poppk-foce/model-management-demo
#
# This script assumes you have already installed and set up bbi. For details
# on getting set up with bbr, see:
# https://metrumresearchgroup.github.io/bbr/articles/getting-started.html#setup


library(bbr)
library(tidyverse)
library(here)

# define model dir and load tags
MODEL_DIR <- here::here("./model/pk")
MODEL_DIR2 <- here::here("./model/pk/106-sir-sirdf")
MODEL_DIR3 <- here::here("./model/pk/106-sir-mmratio")
MODEL_DIR4 <- here::here("./model/pk/001b-sir-sirdf")
MODEL_DIR5 <- here::here("./model/pk/001b-sir-mmratio")
MODEL_DIR6 <- here::here("./model/pk/001b-sir-iaccept")

source("./script/functions-model.R")

############################################
# CHECK FOR BBI INSTALLATION AND CONFIG 
############################################

# The code below checks that you have everything configured to begin modeling
# with bbr. This code can be deleted once everything is working correctly.

# To check if you have bbi installed and configured, run `bbi_version()`
bbi_version()
# If this doesn't return a version number, see 
# if (getOption("bbr.bbi_exe_path") == "bbi") {
#   stop("options('bbr.bbi_exe_path') should be getting set in your .Rprofile. Make sure this is happening before continuing.")
# } else {
#   use_bbi()
# }


# The first time you are modeling in a new directory, you will need to "intialize" bbi.
# The bbi_init() function will create a bbi.yaml, with the default settings, in the 
# specified directory. 
# 
# To check you have initialized bbi, try to read in the `bbi.yaml` file.
file.path(MODEL_DIR6, "bbi.yaml") %>% yaml::read_yaml() %>% names()
# If this errors, run `bbi_init()`:

bbi_init(.dir = MODEL_DIR6,            # the directory to create the bbi.yaml in
         .nonmem_dir = "/opt/NONMEM", # location of NONMEM installation
         .nonmem_version = "nm75")  # default NONMEM version to use

# Note this only needs to be done _once for each folder_ you are modeling in. Once the bbi.yaml exists, 
# you will not need to run `bbi_init()` again unless you want to create another one; for example if you 
# move to modeling in a different directory.
#
# For more details on the `bbi.yaml` file and its usage, see:
# https://metrumresearchgroup.github.io/bbr/articles/getting-started.html#bbi-yaml-configuration-file

# mod106 <- new_model(file.path(MODEL_DIR, "106")) # make new model (only run if models fit for the first time)
mod106 <- read_model(file.path(MODEL_DIR, "106")) # read model
.p <- submit_model(mod106, .mode = "local", .wait = FALSE, 
                   .bbi_args = list(overwrite = TRUE)) # submit model
.s <- mod106 %>% model_summary() # model summary
.s

########################
# sir model
########################

mod106sir <- copy_model_from(.parent_mod = mod106, 
                             .new_model = "106-sir", 
                             .inherit_tags = TRUE) %>% 
  update_run_number()

edit_model(mod106sir)

mod106sir <- read_model(file.path(MODEL_DIR, "106-sir"))

.p <- submit_model(mod106sir, .mode = "local", .wait = FALSE,
                   .bbi_args = list(overwrite = TRUE)) # submit model

# mod106sir <- mod106sir %>% add_bbi_args(list(parallel = TRUE, threads = 4))
# 
# .p <- mod106sir %>% submit_model(.bbi_args = list(overwrite = TRUE))

.s <- mod106sir %>% model_summary()

.s %>% param_estimates() %>% 
  mutate(rse = stderr/estimate) %>% 
  filter(fixed == FALSE) %>% 
  mutate(exp = exp(estimate)) %>% 
  # knitr::kable()
  view()

########################
# sir model try no $ETAS
########################

mod106sir2 <- copy_model_from(.parent_mod = mod106sir, 
                              .new_model = "106-sir-no-etas", 
                              .inherit_tags = TRUE) %>% 
  update_run_number()

edit_model(mod106sir2)

mod106sir2 <- read_model(file.path(MODEL_DIR, "106-sir-no-etas"))

.p <- submit_model(mod106sir2, .mode = "local", .wait = FALSE,
                   .bbi_args = list(overwrite = TRUE)) # submit model

# mod106sir2 <- mod106sir2 %>% add_bbi_args(list(parallel = TRUE, threads = 4))
# 
# .p <- mod106sir2 %>% submit_model(.bbi_args = list(overwrite = TRUE))

.s <- mod106sir2 %>% model_summary()

.s %>% param_estimates() %>% 
  mutate(rse = stderr/estimate) %>% 
  filter(fixed == FALSE) %>% 
  mutate(exp = exp(estimate)) %>% 
  # knitr::kable()
  view()

########################
# sir model (test SIRDF)
########################

# mod106sir1 <- new_model(file.path(MODEL_DIR2, "106-sir-1"))
# mod106sir2 <- new_model(file.path(MODEL_DIR2, "106-sir-2"))
# mod106sir3 <- new_model(file.path(MODEL_DIR2, "106-sir-3"))
# mod106sir4 <- new_model(file.path(MODEL_DIR2, "106-sir-4"))

mod106sir1 <- read_model(file.path(MODEL_DIR2, "106-sir-1"))
mod106sir2 <- read_model(file.path(MODEL_DIR2, "106-sir-2"))
mod106sir3 <- read_model(file.path(MODEL_DIR2, "106-sir-3"))
mod106sir4 <- read_model(file.path(MODEL_DIR2, "106-sir-4"))

.p <- submit_models(list(mod106sir1, mod106sir2, mod106sir3, mod106sir4),
                    .bbi_args = list(parallel = TRUE, 
                                     threads = 4, 
                                     overwrite = TRUE))

########################
# sir model (test m/M ratio)
########################

# mod106sir1 <- new_model(file.path(MODEL_DIR3, "106-sir-1"))
# mod106sir2 <- new_model(file.path(MODEL_DIR3, "106-sir-2"))
# mod106sir3 <- new_model(file.path(MODEL_DIR3, "106-sir-3"))
# mod106sir4 <- new_model(file.path(MODEL_DIR3, "106-sir-4"))
# mod106sir5 <- new_model(file.path(MODEL_DIR3, "106-sir-5"))

mod106sir1 <- read_model(file.path(MODEL_DIR3, "106-sir-1"))
mod106sir2 <- read_model(file.path(MODEL_DIR3, "106-sir-2"))
mod106sir3 <- read_model(file.path(MODEL_DIR3, "106-sir-3"))
mod106sir4 <- read_model(file.path(MODEL_DIR3, "106-sir-4"))
mod106sir5 <- read_model(file.path(MODEL_DIR3, "106-sir-5"))

.p <- submit_models(list(mod106sir1, mod106sir2, mod106sir3, mod106sir4, mod106sir5),
                    .bbi_args = list(parallel = TRUE, 
                                     threads = 4, 
                                     overwrite = TRUE))


# csl0506f model ----------------------------------------------------------

mod001b <- new_model(file.path(MODEL_DIR, "001b")) # make new model (only run if models fit for the first time)
mod001b <- read_model(file.path(MODEL_DIR, "001b")) # read model
.p <- submit_model(mod001b, .mode = "local", .wait = FALSE, 
                   .bbi_args = list(overwrite = TRUE)) # submit model
.s <- mod001b %>% model_summary() # model summary
.s

########################
# 001b sir model
########################

mod001bsir <- copy_model_from(.parent_mod = mod001b, 
                              .new_model = "001b-sir", 
                              .inherit_tags = TRUE) %>% 
  update_run_number()

edit_model(mod001bsir)

mod106sir <- read_model(file.path(MODEL_DIR, "001b-sir"))

.p <- submit_model(mod001bsir, .mode = "local", .wait = FALSE,
                   .bbi_args = list(overwrite = TRUE)) # submit model

# mod106sir <- mod106sir %>% add_bbi_args(list(parallel = TRUE, threads = 4))
# 
# .p <- mod106sir %>% submit_model(.bbi_args = list(overwrite = TRUE))

.s <- mod001bsir %>% model_summary()

.s %>% param_estimates() %>% 
  mutate(rse = stderr/estimate) %>% 
  filter(fixed == FALSE) %>% 
  mutate(exp = exp(estimate)) %>% 
  # knitr::kable()
  view()

########################
# sir model (test SIRDF)
########################

# mod001bsir1 <- new_model(file.path(MODEL_DIR4, "001b-sir-1"))
# mod001bsir2 <- new_model(file.path(MODEL_DIR4, "001b-sir-2"))
# mod001bsir3 <- new_model(file.path(MODEL_DIR4, "001b-sir-3"))
# mod001bsir4 <- new_model(file.path(MODEL_DIR4, "001b-sir-4"))

mod001bsir1 <- read_model(file.path(MODEL_DIR4, "001b-sir-1"))
mod001bsir2 <- read_model(file.path(MODEL_DIR4, "001b-sir-2"))
mod001bsir3 <- read_model(file.path(MODEL_DIR4, "001b-sir-3"))
mod001bsir4 <- read_model(file.path(MODEL_DIR4, "001b-sir-4"))

.p <- submit_models(list(mod001bsir1, mod001bsir2, mod001bsir3, mod001bsir4),
                    .bbi_args = list(parallel = TRUE, 
                                     threads = 4, 
                                     overwrite = TRUE))

########################
# sir model (test m/M ratio)
########################

# mod001bsir1 <- new_model(file.path(MODEL_DIR5, "001b-sir-1"))
# mod001bsir2 <- new_model(file.path(MODEL_DIR5, "001b-sir-2"))
# mod001bsir3 <- new_model(file.path(MODEL_DIR5, "001b-sir-3"))
# mod001bsir4 <- new_model(file.path(MODEL_DIR5, "001b-sir-4"))
# mod001bsir5 <- new_model(file.path(MODEL_DIR5, "001b-sir-5"))

mod001bsir1 <- read_model(file.path(MODEL_DIR5, "001b-sir-1"))
mod001bsir2 <- read_model(file.path(MODEL_DIR5, "001b-sir-2"))
mod001bsir3 <- read_model(file.path(MODEL_DIR5, "001b-sir-3"))
mod001bsir4 <- read_model(file.path(MODEL_DIR5, "001b-sir-4"))
mod001bsir5 <- read_model(file.path(MODEL_DIR5, "001b-sir-5"))

.p <- submit_models(list(mod001bsir1, mod001bsir2, mod001bsir3, mod001bsir4, mod001bsir5),
                    .bbi_args = list(parallel = TRUE, 
                                     threads = 4, 
                                     overwrite = TRUE))



########################
# sir model (test IACCEPT)
########################

mod001bsir1 <- new_model(file.path(MODEL_DIR6, "001b-sir-1"))
mod001bsir2 <- new_model(file.path(MODEL_DIR6, "001b-sir-2"))
mod001bsir3 <- new_model(file.path(MODEL_DIR6, "001b-sir-3"))
mod001bsir4 <- new_model(file.path(MODEL_DIR6, "001b-sir-4"))

mod001bsir1 <- read_model(file.path(MODEL_DIR6, "001b-sir-1"))
mod001bsir2 <- read_model(file.path(MODEL_DIR6, "001b-sir-2"))
mod001bsir3 <- read_model(file.path(MODEL_DIR6, "001b-sir-3"))
mod001bsir4 <- read_model(file.path(MODEL_DIR6, "001b-sir-4"))

.p <- submit_models(list(mod001bsir1, mod001bsir2, mod001bsir3, mod001bsir4),
                    .bbi_args = list(parallel = TRUE, 
                                     threads = 4, 
                                     overwrite = TRUE))

