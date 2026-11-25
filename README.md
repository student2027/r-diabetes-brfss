# Physical Activity and Diabetes Prevalence in US Adults — R version

An R analysis of CDC Behavioral Risk Factor Surveillance System (BRFSS) 2023 data. This is the R companion to the SAS project at https://github.com/student2027/sas-diabetes-brfss — same research question, same dataset, implemented in R.

## Research question

Is leisure-time physical activity associated with self-reported diabetes among US adults, after controlling for age, sex, BMI category, education, and income?

## Dataset

CDC Behavioral Risk Factor Surveillance System (BRFSS) 2023, public-use data
(433,323 records; 345 variables in the SAS transport file).

### Get the real data

1. Go to the CDC 2023 BRFSS data page:
   https://www.cdc.gov/brfss/annual_data/annual_2023.html
2. Download **"2023 BRFSS Data (SAS Transport Format)" [ZIP – 64.3 MB]**
   (February 2025 update). Unzip it — inside is the SAS transport file
   **`LLCP2023.XPT`** (combined landline and cell phone data, LLCP2023).
3. Also download the **2023 BRFSS Codebook** from the same page and verify
   all variable names and codes against it before running — start by
   inspecting the data with `str()` / `summary()`.

### Demo run (no download needed)

`analysis.R` runs as-is on the included simulated sample,
`data/brfss2023_sample.csv` (n = 2,000, same variable names and codes).
Demo results are simulated and must not be reported as BRFSS results;
see `data/README_sample.md`. For real data, set `run_mode <- "real"`
and `brfss_file` in `analysis.R` to the downloaded file
(`haven::read_xpt("LLCP2023.XPT")`, or a CSV exported from SAS).

## Variables

| Variable | Role | Notes |
|---|---|---|
| `DIABETE4` | Outcome | Ever told diabetes |
| `_TOTINDA` | Exposure | Leisure-time physical activity |
| `_AGEG5YR` | Confounder | Age group |
| `SEX1` | Confounder | Sex |
| `_BMI5CAT` | Confounder | BMI category |
| `_EDUCAG` | Confounder | Education |
| `_INCOMG1` | Confounder | Income group |

Recode missing / refused / don't-know responses to missing. See `analysis.R` for the recodes.

## How to run

1. Install R and RStudio, then install the packages used by `analysis.R` (`dplyr`, `readr`, `broom`):
   ```r
   install.packages(c("dplyr", "readr", "broom"))
   ```
2. **Demo:** just run `analysis.R` top to bottom — it uses the included
   simulated sample by default (`run_mode <- "demo"`).
   **Real data:** download BRFSS 2023 as above, then in `analysis.R` set
   `run_mode <- "real"` and `brfss_file` to the downloaded file, and run
   the script top to bottom.

## Analysis steps

1. Load and inspect the data
2. Data cleaning and validation (recodes, range and frequency checks)
3. Descriptive analysis (tables, cross-tabulations)
4. Modelling (`glm()` logistic regression — unadjusted, then adjusted)
5. Quality control (check Ns at each step, compare unadjusted vs adjusted results)
6. Reporting (tidy odds ratios with 95% confidence intervals)

## Results

Results are in `results.md` — to be completed after running the script. No results are claimed before running.

## Limitations

Cross-sectional, self-reported data. No causal claim can be made from this analysis.

## Skills demonstrated

R / RStudio, tidyverse (`dplyr`, `readr`), data cleaning and validation, descriptive analysis, logistic regression with `glm()`, tidy model output with `broom`, reproducible analysis.
