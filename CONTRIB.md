# Contributing to Newt

Interested in improving Newt? Great!

# One-time setup

1. At https://github.com/megalisp/newt click the `Fork` button.

2. `git clone` your forked repo to your computer.

3. Run `make install`. This installs a few Racket packages needed by
   Newt. Also it lets you run Newt just like normal users do: `raco
   newt`.

# Ongoing development

To run day-to-day tests: `make test`. This runs tests in any `test`
submodule in the project (including any you add).

There are some extra tests (which Travis CI will run against your pull
request). To run them: `make ci-extra-checks`. See `Makefile` for
more details if you're curious.

# The `example` project

One thing that `make ci-extra-checks` does is build an example Newt
blog project in the `example` directory. Making Newt build this can be
a good way to test your code. If you introduce a new feature, consider
adding a new post to that site that illustrates and exercises your
feature.

# Sharing your change

To share your bug fix or new feature, please create a [pull request].

If you're contemplating a big change, consider opening an [issue]
early to discuss it and get feedback before doing all the work.

[pull request]: https://github.com/megalisp/newt/pulls
[issue]: https://github.com/megalisp/newt/issues
