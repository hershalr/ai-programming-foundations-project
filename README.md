# AI Programming Foundations — Project 01

**Student:** Hershal Rooplall

## Repository

Public GitHub repository (multiple commits + `develop` branch beyond `main`):

https://github.com/hershalr/ai-programming-foundations-project

## Project Description

This project builds a reproducible tabular data workflow: load a real World Bank fiscal-space dataset, reshape and clean it with documented Python functions, run exploratory analysis, and produce three labeled visualizations. No machine learning models are trained. The goal is a professional foundation for later ML, deep learning, and agentic modules.

**Dataset:** World Bank *A Cross-Country Database of Fiscal Space* (`data/WB_CCDFS_WIDEF.csv`), from `gs://cce-wb-data360/cce-world-bank-data/raw-export/A Cross-Country Database of Fiscal Space/` ([dataset documentation / WPS8157](https://documents1.worldbank.org/curated/en/601211501678994591/pdf/WPS8157.pdf)).

## How to Run

```bash
pip install -r requirements.txt
jupyter notebook data_workflow.ipynb
```

Run all notebook cells top to bottom from the project root so `data/WB_CCDFS_WIDEF.csv` resolves correctly. Optional PDF export of the written report: `bash convert_reports.sh` (requires [pandoc](https://pandoc.org/)), or `pandoc module_summary.md -o module_summary.pdf`.

## Bias Awareness

Missingness is not random with respect to development and market structure. Market-access indicators are sparse for countries without traded sovereign debt; treating those blanks as ignorable or filling them would bias comparisons toward economies that issue and price debt instruments. Dropping empty observations after reshape is honest about availability but still produces samples skewed toward better-covered indicators and years.

Cleaning choices can also mislead if reviewers forget that dropped rows remove country–years rather than “clean noise.” This project mitigates that risk by (a) documenting drop counts, (b) plotting coverage explicitly in Figure 1, and (c) avoiding income-group or regional claims unless an external mapping is joined carefully. Next steps for stronger responsible practice would include documenting indicator-level inclusion rules before any modeling module and reporting effective sample sizes alongside every comparative statistic.

## Reflection

**Why cleaning was necessary.** The source file is wide by year (1990–2022), with many empty cells for non-reported country–indicator–years. Melting to long form and dropping missing or non-numeric `OBS_VALUE`s was required so EDA and plots use observed measurements only—not invented zeros or imputed debt ratios.

**What the workflow shows.** Country coverage varies sharply across indicators; sparse market-access series would over-represent economies with deeper capital markets if treated as globally representative. Debt-to-GDP style distributions are wide with a long right tail, and selected large economies diverge in level and crisis-period paths.

**Assumptions and limitations.** Blanks mean non-reporting, not zero. Figures are descriptive, not causal. Selected economies illustrate time variation; they are not a random sample. Analytic samples after dropping empties are not the same as the full list of economies in the database header.

## Future Integration Reflections

### 1. How would this workflow change for machine learning?

The current pipeline stops at a clean long panel and descriptive EDA. For supervised ML I would (1) choose a prediction target (for example next-year debt-to-GDP or a binary fiscal-stress label), (2) build feature tables with lags and rolling summaries per country–indicator, (3) define a time-aware train/validation/test split so future years are never used to predict the past, (4) encode categorical identifiers carefully (or drop high-cardinality IDs), and (5) report metrics on a held-out window while still publishing coverage and effective sample size. Imputation—if used at all—would be fit only on training folds and justified against the “missing means non-reporting” assumption.

### 2. How would you prepare the data for a neural network?

Neural nets need fixed-shape numeric tensors and consistent scaling. I would keep the long panel, then either (a) build country–year feature vectors (selected indicators as columns, standardized continuous inputs) or (b) build short sequences of recent years per economy for a sequence model. Steps would include: align a common year grid, decide an explicit missingness strategy (mask channel vs. drop incomplete rows), standardize features using training-set statistics only, one-hot or embed categorical fields if retained, and verify that train/val/test tensors have identical feature order and no leakage from future periods.

### 3. What parts of this project could an AI agent automate?

An agent could automate routine, checkable steps: verifying the CSV path and schema, running the reshape/drop functions, regenerating Figure 1–3, refreshing `requirements.txt` after environment changes, opening a PR on a `develop` branch with a short changelog, and flagging coverage drops below a threshold. Human review should remain required for analytic claims, bias interpretation, indicator selection, and any decision to impute or model—because those choices change the meaning of the sample, not just the code path.
