# Results — DEMO RUN on simulated data

> **These numbers are from the included SIMULATED sample
> (`data/brfss2023_sample.csv`, n = 2,000), not from real BRFSS data.**
> The sample was generated with a known, invented association (see
> `data/README_sample.md`), so these results only show that the code
> runs end-to-end and what its output looks like. Do not report them
> as BRFSS findings. Re-run `analysis.R` with `run_mode <- "real"` on
> the real BRFSS 2023 file (see README.md) and replace this section
> with the real results.

Demo run: R 4.3.3, `analysis.R` with `run_mode = "demo"`, 22 Nov 2026.
Exit code 0; the script ran top to bottom and wrote
`adjusted_odds_ratios.csv`.

## Sample (demo)

- Total N in sample file: 2,000
- N after cleaning (complete cases for outcome, exposure, and confounders): 1,883
- Diabetes prevalence (DIABETE4 == 1, among non-missing): 9.2% (176 of 1,922)
- Physically active (_TOTINDA == 1, among non-missing): 72.1%

## Descriptive (demo)

| Group | Diabetes % | n with diabetes / n in group |
|---|---|---|
| Physically active | 7.8% | 108 / 1,382 |
| Not physically active | 12.2% | 65 / 532 |

## Logistic regression (demo)

Odds ratios are for physically active (active = 1) vs not active (active = 0).

| Model | Odds ratio | 95% CI | p-value |
|---|---|---|---|
| Unadjusted | 0.61 | 0.44–0.85 | 0.003 |
| Adjusted (age, sex, BMI, education, income) | 0.58 | 0.42–0.82 | 0.002 |

## Interpretation (demo only)

In this simulated sample, physically active adults had lower odds of
diabetes than inactive adults, and the association stayed in the same
direction after adjusting for age, sex, BMI category, education, and
income. This is expected: the simulation was built with inactivity
raising diabetes risk. It proves the code works — it says nothing
about real US adults.

## Limitations

Cross-sectional, self-reported data. No causal claim. And these
particular numbers come from simulated data, so they must not be
quoted as BRFSS results.
