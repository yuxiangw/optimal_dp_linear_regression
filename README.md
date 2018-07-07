# Optimal and adaptive differentially private linear regression

This package contains the Matlab code used to reproduce the experimental results of the following paper:

* Wang, Yu-Xiang. "Revisiting differentially private linear regression: optimal and adaptive prediction & estimation in unbounded domain." in Uncertainties in Artificial Intelligence (2018).

Arxiv [https://arxiv.org/abs/1803.02596](https://arxiv.org/abs/1803.02596)

* TL;DR: AdaOPS and AdaSSP can automatically adapts to structures of the data set while preserving (eps,delta)-Differential Privacy. 

## bibtex entry:

```
@inproceedings{wang2018revisiting,
  title={Revisiting differentially private linear regression: optimal and adaptive prediction \& estimation in unbounded domain},
  author={Wang, Yu-Xiang},
  booktitle={Uncertainty in Artificial Intelligence (UAI-18)},
  year={2018}
}
```

## Sample outputs:

### 

<img src="https://github.com/yuxiangw/optimal_dp_linear_regression/blob/master/figures/results_bike.png" alt="Prediction on the `bike' data set" width="400x"/>  <img src="https://github.com/yuxiangw/optimal_dp_linear_regression/blob/master/figures/Gaussian_MSE_eps_1.png" alt="Estimation of linear Gaussian model parameters" width="400x"/>

Left: Statistical learning: Varying \eps, \delta = 1e-6.  Right: Statistical estimation: \eps = 1.0, \delta = 1e-6



## Where are the 36 data sets used in this repository coming from?

* Original data source

[UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/index.php)

* Actual data source

Zichao Yang: [https://github.com/zcyang](https://github.com/zcyang)

* Yang, Zichao, Andrew Wilson, Alex Smola, and Le Song. "A la carte–learning fast kernels." In Artificial Intelligence and Statistics, pp. 1098-1106. 2015.

## How to use the code?

1. (Optionally) get the four somewhat large data sets (all other 32 data sets are stored in the pre-processed format)
```
cd data
chmod 755 wget_largedata.sh
./wget_largedata.sh
```

You might need to do some further processing to those four data sets to ensure all fields are numerical, there are no headers and the last column is the label to predict.

2. Process the data sets into `*.mat` files. In MATLAB:
```
cd data
generatedata_all
```
This will process the datasets in standard ways.

3. Run UCI data experiments

Run `code/exp_uci.m`

4. Run synthetic data experiments

Run `code/exp_simulation.m`