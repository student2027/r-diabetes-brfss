# ==========================================================================
# Physical Activity and Diabetes Prevalence in US Adults — R version
# R analysis of CDC BRFSS 2023 data
# Companion to the SAS project:
#   https://github.com/student2027/sas-diabetes-brfss
# HOW TO RUN
# -----------
# DEMO (runs as-is, no download needed): the script reads the included
# simulated sample, data/brfss2023_sample.csv (n = 2000, same variable
# names and codes as BRFSS 2023, generated with set.seed(2023) — see
# data/README_sample.md). It is SIMULATED data for testing the code only;
# its results are NOT real BRFSS results.
# REAL DATA: download the real BRFSS 2023 file (see README.md, "Get the
# real data") and set brfss_file below to its path, e.g.
#   brfss_file <- "LLCP2023.XPT"   # then use haven::read_xpt(brfss_file)
# or export it to CSV from SAS first and point brfss_file at that CSV.
# VERIFY all variable names and codes against the 2023 BRFSS codebook
# before running on real data.
# ==========================================================================

library(dplyr)    # %>%, mutate(), case_when(), summarise()
library(readr)    # read_csv(), write_csv()
library(broom)    # tidy()

# Step 1: Load and inspect ---------------------------------------------------
# Set to "demo" to run on the included simulated sample, or "real" + a
# file path to run on the real BRFSS 2023 data.
run_mode <- "demo"   # "demo" or "real"
brfss_file <- "data/brfss2023_sample.csv"  # demo sample (default)
# For real data, uncomment one of these instead:
# brfss_file <- "LLCP2023.XPT"          # SAS transport file from CDC
# brfss_file <- "llcp2023.csv"          # CSV exported from SAS

if (run_mode == "real" && grepl("\\.xpt$", brfss_file, ignore.case = TRUE)) {
  # install.packages("haven")  # if needed
  brfss <- haven::read_xpt(brfss_file)
} else {
  brfss <- read_csv(brfss_file, show_col_types = FALSE)
}
message("Running on: ", brfss_file, " (mode: ", run_mode, ")")
message("Rows loaded: ", nrow(brfss))

str(brfss)
summary(brfss)

# Step 2: Data cleaning and validation ---------------------------------------
brfss_clean <- brfss %>%
  mutate(
    # Outcome: ever told diabetes.
    # Recode missing / refused / don't-know to NA.
    # Exclude gestational diabetes and pre-diabetes as appropriate
    # for your research question; document the choice here.
    diabetes = case_when(
      DIABETE4 == 1 ~ 1,
      DIABETE4 == 2 ~ 0,
      TRUE ~ NA_real_
    ),
    # Exposure: leisure-time physical activity
    active = case_when(
      `_TOTINDA` == 1 ~ 1,
      `_TOTINDA` == 2 ~ 0,
      TRUE ~ NA_real_
    ),
    agegrp = if_else(`_AGEG5YR` == 14, NA_real_, as.numeric(`_AGEG5YR`)),
    sex = if_else(SEX1 == 9, NA_real_, as.numeric(SEX1)),
    bmi_cat = `_BMI5CAT`,
    educ = if_else(`_EDUCAG` == 9, NA_real_, as.numeric(`_EDUCAG`)),
    income = if_else(`_INCOMG1` == 9, NA_real_, as.numeric(`_INCOMG1`))
  )

# Check Ns and frequencies after cleaning
brfss_clean %>%
  summarise(
    n_total = n(),
    n_complete = sum(complete.cases(diabetes, active, agegrp, sex, bmi_cat, educ, income)),
    diabetes_prev = mean(diabetes, na.rm = TRUE),
    active_pct = mean(active, na.rm = TRUE)
  )

# Step 3: Descriptive analysis ------------------------------------------------
table(brfss_clean$diabetes, brfss_clean$active, useNA = "ifany")
table(brfss_clean$diabetes, brfss_clean$agegrp, useNA = "ifany")
table(brfss_clean$diabetes, brfss_clean$sex, useNA = "ifany")

# Step 4: Modelling — logistic regression --------------------------------------
# Unadjusted
model_unadjusted <- glm(
  diabetes ~ active,
  data = brfss_clean,
  family = binomial()
)
tidy(model_unadjusted, exponentiate = TRUE, conf.int = TRUE)

# Adjusted for age, sex, BMI category, education, and income
model_adjusted <- glm(
  diabetes ~ active + factor(agegrp) + factor(sex) +
    factor(bmi_cat) + factor(educ) + factor(income),
  data = brfss_clean,
  family = binomial()
)
tidy(model_adjusted, exponentiate = TRUE, conf.int = TRUE)

# Step 5: Quality control — check Ns at each step and compare
# unadjusted vs adjusted results before reporting.

# Step 6: Reporting ------------------------------------------------------------
# Save tidy adjusted results
write_csv(
  tidy(model_adjusted, exponentiate = TRUE, conf.int = TRUE),
  "adjusted_odds_ratios.csv"
)
