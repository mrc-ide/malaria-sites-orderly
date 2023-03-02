# orderly

This is an [`orderly`](https://github.com/vimc/orderly) project.  The directories are:

* `src`: create new reports here
* `archive`: versioned results of running your report
* `data`: copies of data used in the reports

To run the pipeline:
`./pipeline.R`

To bring up a copy of OrderlyWeb to explore the resulting reports, from this directory run:
`docker run -v $PWD:/orderly -p 8888:8888 vimc/orderly-web-standalone:mrc-3850`

This will start a server at http://localhost:8888
