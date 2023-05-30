# Malaria Sites Orderly
 
This is an [`orderly3`](https://github.com/mrc-ide/orderly3) project.

R packages that should be installed from GitHub:
* [orderly3](https://github.com/mrc-ide/orderly3)
* [cart](https://github.com/mrc-ide/cart)

Report sources are contained in the `src` directory. To start running reports locally, 
you will first need to initialise the repo with `outpack::outpack_init(".")`.

Individual reports can then be run, e.g. `orderly3::orderly_run("prepare_global_inputs", root = ".")`

An example pipeline script can be found in `pipeline.R`.

Once reports have been run, the results will appear in your `archive` directory, under unique packet ids. Failed reports 
will appear in `drafts` where you will be able to inspect log files that should help with debugging.
You should not commit these to GitHub; ultimately all reports will be run remotely on, or run locally and then uploaded to, `malaria.dide.ic.ac.uk` 
and that is where canonical copies of the results will live.
