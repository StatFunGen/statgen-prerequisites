# statgen-prerequisites
Computational codes accompany the 1-day lecture on statistics background in statistical genetics

# Table of Content

The notation table for this course can be found [here](https://github.com/gaow/statgen-prerequisites/blob/main/Notations.ipynb).

| Section | Subsection | Topic | Notebook | Graphical Summary |
|---------|------------|-------|----------|-------------------|
| **Basic Concepts** | | Genotype Coding | [genotype_coding](https://github.com/gaow/statgen-prerequisites/blob/main/genotype_coding.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/genotype_coding.svg) |
| | | Minor Allele Frequency | [MAF](https://github.com/gaow/statgen-prerequisites/blob/main/MAF.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/MAF.svg) |
| | | Hardy-Weinberg Equilibrium | [HWE](https://github.com/gaow/statgen-prerequisites/blob/main/HWE.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/HWE.svg) |
| **Correlation** |Between variants | Linkage Disequilibrium | [LD](https://github.com/gaow/statgen-prerequisites/blob/main/LD.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/LD.svg) |
| | | LD Score | [LD_score](https://github.com/gaow/statgen-prerequisites/blob/main/LD_score.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/LD_score.svg) |
| |Between individuals | Genetic Relationship Matrix | [GRM](https://github.com/gaow/statgen-prerequisites/blob/main/GRM.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/GRM.svg) |
| **Regression Models** |Basic model | Ordinary Least Squares | [OLS](https://github.com/gaow/statgen-prerequisites/blob/main/OLS.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/OLS.svg) |
| | | Summary Statistics | [summary_statistics](https://github.com/gaow/statgen-prerequisites/blob/main/summary_statistics.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/summary_statistics.svg) |
| | Extend to binary outcome| Odds Ratio | [OR](https://github.com/gaow/statgen-prerequisites/blob/main/OR.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/OR.svg) |
| | From fixed effect model to random effect model| Random Effects / Linear Mixed Models | [REM_LMM](https://github.com/gaow/statgen-prerequisites/blob/main/REM_LMM.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/REM_LMM.svg) |
| | | Proportion of Variance Explained | [PVE](https://github.com/gaow/statgen-prerequisites/blob/main/PVE.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/PVE.svg) |
| | Single vs multiple marker model| Marginal vs. Joint Effects | [marginal_joint_effects](https://github.com/gaow/statgen-prerequisites/blob/main/marginal_joint_effects.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/marginal_joint_effects.svg) |
| | Covariates| Confounders | [confounder](https://github.com/gaow/statgen-prerequisites/blob/main/confounder.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/confounder.svg) |
| | | Mediators | [mediator](https://github.com/gaow/statgen-prerequisites/blob/main/mediator.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/mediator.svg) |
| | | Colliders | [collider](https://github.com/gaow/statgen-prerequisites/blob/main/collider.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/collider.svg) |
| |Multiple studies| Meta-Analysis | [meta_analysis](https://github.com/gaow/statgen-prerequisites/blob/main/meta_analysis.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/meta_analysis.svg) |
| **Statistical Inference** | Likelihood and MLE | Likelihood | [likelihood](https://github.com/gaow/statgen-prerequisites/blob/main/likelihood.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/likelihood.svg) |
| | | Maximum Likelihood Estimation | [maximum_likelihood_estimation](https://github.com/gaow/statgen-prerequisites/blob/main/maximum_likelihood_estimation.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/maximum_likelihood_estimation.svg) |
| | LR and LRT | Likelihood Ratio | [likelihood_ratio](https://github.com/gaow/statgen-prerequisites/blob/main/likelihood_ratio.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/likelihood_ratio.svg) |
| | | Likelihood Ratio Test | [likelihood_ratio_test](https://github.com/gaow/statgen-prerequisites/blob/main/likelihood_ratio_test.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/likelihood_ratio_test.svg) |
| **Bayesian Methods** | Bayes Factor | Bayes Factor | [Bayes_factor](https://github.com/gaow/statgen-prerequisites/blob/main/Bayes_factor.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/Bayes_factor.svg) |
| | | P-value versus Bayes Factor | [p_value_versus_Bayes_factor](https://github.com/gaow/statgen-prerequisites/blob/main/p_value_versus_Bayes_factor.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/p_value_versus_Bayes_factor.svg) |
| | Bayesian Models | Bayesian Normal Mean Model | [Bayesian_normal_mean_model](https://github.com/gaow/statgen-prerequisites/blob/main/Bayesian_normal_mean_model.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/Bayesian_normal_mean_model.svg) |
| | | Bayesian Multivariate Normal Mean Model | [Bayesian_multivariate_normal_mean_model](https://github.com/gaow/statgen-prerequisites/blob/main/Bayesian_multivariate_normal_mean_model.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/Bayesian_multivariate_normal_mean_model.svg) |
| | | Bayesian Mixture Model | [Bayesian_mixture_model](https://github.com/gaow/statgen-prerequisites/blob/main/Bayesian_mixture_model.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/Bayesian_mixture_model.svg) |
| | Model Selection and Averaging | Bayesian Model Comparison | [Bayesian_model_comparison](https://github.com/gaow/statgen-prerequisites/blob/main/Bayesian_model_comparison.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/Bayesian_model_comparison.svg) |
| | | Bayesian Model Averaging | [Bayesian_model_averaging](https://github.com/gaow/statgen-prerequisites/blob/main/Bayesian_model_averaging.ipynb) | [SVG](https://github.com/gaow/statgen-prerequisites/blob/main/cartoons/Bayesian_model_averaging.svg) |

# References

- [statgen_equation](https://github.com/cumc/handson-tutorials/blob/main/contents/statgen_basic/statgen_equations.ipynb)
  - [original version from Robert Maier](https://rawgit.com/uqrmaie1/statgen_equations/master/statgen_equations.html)
- [five minutes Bayesian from Matthew Stephens](https://stephens999.github.io/fiveMinuteStats/index.html)
