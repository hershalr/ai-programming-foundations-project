# Module Summary: AI Programming Foundations Project

**Student:** Hershal Rooplall  
**Course module:** AI Programming Foundations  
**Companion notebook:** `data_workflow.ipynb`

---

## Overview

This project builds a reproducible tabular data workflow—ingestion, cleaning, exploratory analysis, and visualization—without training machine learning models. The analysis uses the World Bank *A Cross-Country Database of Fiscal Space* (`WB_CCDFS_WIDEF.csv`), sourced from `gs://cce-wb-data360/cce-world-bank-data/raw-export/A Cross-Country Database of Fiscal Space/` and documented in the World Bank working paper for the database ([WPS8157](https://documents1.worldbank.org/curated/en/601211501678994591/pdf/WPS8157.pdf)). The deliverable demonstrates professional Python practice for later supervised learning and industry-synthesis modules.

---

## Dataset Description

The fiscal-space database compiles indicators that describe how much room governments have to raise spending or cut taxes without jeopardizing debt sustainability or market access (Kose et al., 2022). The wide CSV used here has **3,375 rows** and **49 columns**: identifier and label fields (economy, indicator codes/labels, units) plus **33 annual year columns from 1990 through 2022**. Coverage spans **202 economies** and **23 indicators** grouped into government debt sustainability, balance-sheet composition, external and private sector debt, and market access. Analysis focuses on `REF_AREA` / `REF_AREA_LABEL`, `INDICATOR` / `INDICATOR_LABEL`, year columns melted into `TIME_PERIOD`, and numeric `OBS_VALUE`. Empty year cells are common for sparse indicators and economies without traded debt instruments.

---

## Workflow Description

### Ingestion

The notebook imports NumPy, pandas, Matplotlib, and Seaborn, then loads `data/WB_CCDFS_WIDEF.csv` with an explicit path check. Column inspection separates metadata from digit-named year fields so reshape logic does not hard-code a fixed year list.

### Cleaning

Two documented functions reshape and sanitize the panel. `wide_to_long` melts year columns into `TIME_PERIOD` and `OBS_VALUE` while preserving identifiers. `drop_empty_observations` removes missing or non-numeric values after reshape, treating blanks as non-reported years rather than zeros. This keeps downstream EDA and plots on observed measurements only.

### Exploratory analysis

`explore_fiscal_space` reports row counts, unique countries and indicators, the year span, `OBS_VALUE` summary statistics, the most frequent indicators, and indicators with the fewest reporting economies. Coverage sparsity is treated as an analytic signal, not only a loading defect.

### Visualizations

Three labeled figures support interpretation: country coverage by indicator (Figure 1), the distribution of a core debt-to-GDP style series (Figure 2), and time paths for selected large economies on that same series (Figure 3).

### Summary

A notebook Markdown section and this report state patterns, limitations, and the decision not to impute missing years or claim causal effects. The workflow ends at reproducible EDA.

---

## Key Decisions and Assumptions

1. **Wide-to-long reshape first.** Fiscal-space exports are wide by year; analysis and plotting are clearer as a long country–indicator–year panel. Melting year columns preserves labels needed for readable axes and coverage counts.
2. **Drop blanks; do not impute.** Missing year cells mean non-reporting, not zero debt or zero balance. Imputation would invent values for economies and instruments that do not appear in the source construction (Kose et al., 2022).
3. **EDA prioritizes coverage and a debt-sustainability slice.** Country counts per indicator expose structural missingness; a debt `% of GDP` style indicator anchors distribution and trend plots that reviewers can interpret without specialized market-access jargon.
4. **Figures are descriptive, not causal.** Selected economies (for example USA, DEU, ZAF, BRA, IND, CHN when present) illustrate time variation; they are not a random sample and do not support policy counterfactuals.
5. **Reproducible environment.** Dependencies are pinned in `requirements.txt`, and the notebook path is relative to the project folder so reruns match the documented setup (Peng, 2021).

---

## Results and Interpretation

**Figure 1** shows that country coverage varies sharply across indicators. Some debt-sustainability and fiscal-balance measures appear for many economies, while market-access and certain balance-sheet series are available for far fewer countries. Coverage itself is therefore a finding: comparing “global” averages on sparse indicators would over-represent economies with deeper capital markets.

**Figure 2** summarizes the distribution of a preferred debt-related `% of GDP` indicator (or the most common indicator if that filter is empty). The spread is wide, with a long right tail typical of debt ratios in crisis or highly indebted settings. Units and definitions matter; the plot is interpreted as descriptive scale, not a single universal “fiscal health” score.

**Figure 3** tracks the same indicator over time for a small set of large economies. Paths diverge in level and in crisis-period movements, reinforcing that cross-country level comparisons require matching indicator definitions and that time dynamics differ even when the series name is shared.

Overall, the long panel reshapes cleanly, but uneven reporting—especially for market-access concepts that require traded debt—means analytic samples are not the same as the list of 202 economies in the database header (Kose et al., 2022).

---

## Responsible Practice (Bias and Data Quality)

Missingness is not random with respect to development and market structure. Market-access indicators are sparse for countries without traded sovereign debt; treating those blanks as ignorable or filling them would bias comparisons toward economies that issue and price debt instruments (Kose et al., 2022). Dropping empty observations after reshape is honest about availability but still produces samples skewed toward better-covered indicators and years.

Cleaning choices can also mislead if reviewers forget that dropped rows remove country–years rather than “clean noise.” The project mitigates that risk by (a) documenting drop counts, (b) plotting coverage explicitly in Figure 1, and (c) avoiding income-group or regional claims unless an external mapping is joined carefully. Next steps for stronger responsible practice would include documenting indicator-level inclusion rules before any modeling module and reporting effective sample sizes alongside every comparative statistic.

---

## Reproducibility

Someone else can rerun the work by cloning the public repository at https://github.com/hershalr/ai-programming-foundations-project (branches `main` and `develop`), installing pinned packages with `pip install -r requirements.txt`, and opening `data_workflow.ipynb` from the project root so `data/WB_CCDFS_WIDEF.csv` resolves correctly. Keeping data, notebook, requirements, and this summary in version control—with multiple commits and at least one development branch—matches open reproducible-data-science practice: scripted steps, declared dependencies, and artifacts that can be regenerated without hidden GUI clicks (Peng, 2021). Optional PDF export of this Markdown source uses pandoc: `pandoc module_summary.md -o module_summary.pdf` or `bash convert_reports.sh`.

---

## Sources and Citations / References

Kose, M. A., Kurlat, S., Ohnsorge, F., & Sugawara, N. (2022). A cross-country database of fiscal space. *Journal of International Money and Finance, 128*, 102682. https://doi.org/10.1016/j.jimonfin.2022.102682

Peng, R. D. (2021). *Reproducible data science with Python: An open learning resource*. https://leanpub.com/reproducible-data-science-with-python

World Bank. (n.d.). *A cross-country database of fiscal space* (WB_CCDFS) [Data set]. `gs://cce-wb-data360/cce-world-bank-data/raw-export/A Cross-Country Database of Fiscal Space/`. Related documentation: https://documents1.worldbank.org/curated/en/601211501678994591/pdf/WPS8157.pdf
