# optimal and adaptive differentially private linear regression

This package contains the Matlab code used to reproduce the experimental results of the following paper. 

Wang, Yu-Xiang. "Revisiting differentially private linear regression: optimal and adaptive prediction & estimation in unbounded domain." in Uncertainties in Artificial Intelligence (2018).

Arxiv link [https://arxiv.org/abs/1803.02596]: https://arxiv.org/abs/1803.02596

Such as the one below:

### Statistical learning: Varying $\epsilon$, $\delta = 1e-6$ 

![alt text](https://github.com/yuxiangw/optimal_dp_linear_regression/blob/master/figures/results_bike.png "Prediction on the `bike' data set")

### Statistical estimation: $\epsilon = 1.0, \delta = 1e-6$ 

![alt text](https://github.com/yuxiangw/optimal_dp_linear_regression/blob/master/figures/Gaussian_MSE_eps_1.png "Estimation of linear Gaussian model parameters")


## bibtex entry:

```@inproceedings{wang2018revisiting,
  title={Revisiting differentially private linear regression: optimal and adaptive prediction \& estimation in unbounded domain},
  author={Wang, Yu-Xiang},
  booktitle={Uncertainty in Artificial Intelligence (UAI-18)},
  year={2018}
}
```


## Where are the 36 data sets used in this repository coming from:

Original data source: 
[UCI Machine Learning Repository] https://archive.ics.uci.edu/ml/index.php

Actual data source:  [Zichao Yang] https://github.com/zcyang 

Yang, Zichao, Andrew Wilson, Alex Smola, and Le Song. "A la carte–learning fast kernels." In Artificial Intelligence and Statistics, pp. 1098-1106. 2015.

## How to use the code to reproduce the experiments?

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