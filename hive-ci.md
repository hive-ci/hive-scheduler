---
layout: default
title: Hive CI
---

<img src="/hive-ci/images/hive-ci.png" class="col-md-2 pull-left img-responsive" alt="Test Mine">
<h1 class="pull-right"><a href="https://github.com/hive-ci/hive-ci" class="label label-danger">Github</a></h1>

# Hive CI

{: .lead}
Scheduling tests and view results

<img src="/hive-ci/images/testmite-regressions-01.png" class="col-md-6 pull-right img-responsive" alt="Regression view">

<br />
<br />
<br />

Test Mine is a test result analytics application:

* Aggregate test results for simple analysis
* Keep historic data to check for regressions and study trends
* Compare results across devices
* Spot unreliable tests

Hive CI can be downloaded from [Github.](https://github.com/hive-ci/testmine)



### Get Started

Download the Hive Scheduler software with:

``` bash
$ git clone git@github.com:hive-ci/hive-ci.git
$ cd hive-ci
$ bundle install --without development test
```

Set up the database and assets. If the database username is not `root` the first command will ask for the MySQL root password.

``` bash
$ bundle exec rake setup
```

Start the Hive CI server:

``` bash
$ rails s
```

After Rails has started up go to `http://localhost:3000` in a browser to see the running scheduler.

<h1 class="pull-left"><a href="{{ site.baseurl }}/hive-runner.html" class="label label-danger">Previous</a></h1>
<h1 class="pull-right"><a href="{{ site.baseurl }}/hive-runner.html" class="label label-danger">Next</a></h1>
