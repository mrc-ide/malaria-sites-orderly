# Malaria Sites Orderly
 
This is an [`orderly2`](https://github.com/mrc-ide/orderly2) project.

R packages that should be installed from GitHub:

* [orderly2](https://github.com/mrc-ide/orderly2)
* [cart](https://github.com/mrc-ide/cart)

In addition, from CRAN

* malariaAtlas

Report sources are contained in the `src` directory. To start running reports locally, you will first need to initialise the repo with `orderly2::orderly_init(".")`.

Individual reports can then be run, e.g. `orderly2::orderly_run("prepare_global_inputs")`

An example pipeline script can be found in `pipeline.R`.

Once reports have been run, the results will appear in your `archive` directory, under unique packet ids. Failed reports  will appear in `drafts` where you will be able to inspect log files that should help with debugging. You should not commit these to GitHub; ultimately all reports will be run remotely on, or run locally and then uploaded to, `malaria-orderly.dide.ic.ac.uk` and that is where canonical copies of the results will live.
