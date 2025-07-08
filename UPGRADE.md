Starting with version 0.3, Newt uses
[`web-server/templates`](http://docs.racket-lang.org/web-server/templates.html)
to do more of the work when it comes to layout and appearance, instead
of building the HTML itself using `.newtrc` variables.

If you had started to use Newt before version 0.3:

1. Thank you!

2. You'll need to move some things form `navbar.md`, `footer.md`, and
`homehead.md` to a new template file, `_src/page-template.html`.

3. You'll need to move some things from `.newtrc` to
`_src/page-template.html` and to another new template file,
`_src/post-template.html`.

This should take just a few minutes! (If you have any questions or
problems, please let me know.)

# `navbar.md`

> **NOTE:** This is no longer a special file. You should delete it,
> otherwise Newt will treat it like any other `.md` file in/under `_src`
> and create a `navbar.html` file from it!

In `page-template.html`, create navbar `<li>` items using the
`@nav-item` function. The example `page-template.html` defines "All
Posts" (home) and "About" items. You can add or change:

```html
    <!-- A standard Twitter Bootstrap nav bar -->
    <div class="navbar navbar-inverse">
      <div class="navbar-inner">
        <div class="container">
          <ul class="nav">
            <!-- Notice we can define Racket functions. Here's a
                 helper to check if a nav bar item is for this page, as
                 indiated by `uri-path` -->
            @(define (nav-item uri label [a-attribs ""])
              @list{
                <li@(when (string-ci=? uri uri-path) " class=\"active\"")>
                  <a href="@|uri|"@|a-attribs|>@|label|</a>
                </li> })
            @nav-item["/index.html" "All Posts" " class=\"brand\""]
            @nav-item["/About.html" "About"]
            <!-- ADD YOUR NAV BAR ITEMS HERE -->
          </ul>
        </div>
      </div>
    </div>
```

# `footer.md`

> **NOTE:** This is no longer a special file. You should delete it,
> otherwise Newt will treat it like any other `.md` file in/under `_src`
> and create a `footer.html` file from it!

In `page-template.html`, simply edit the `<footer>` section:

```html
      <footer>
        <hr />
        <p>Site generated
        by <a href="https://github.com/megalisp/newt">Newt</a>,
        the <strong>fr</strong>ozen bl<strong>og</strong> tool.</p>
        <p>Using <a href="http://twitter.github.com/bootstrap/index.html">Bootstrap</a>.</p>
        <p><em>Your legal notice here</em>.</p>
      </footer>
```

# `homehead.md`

> **NOTE:** This is no longer a special file. You should delete it,
> otherwise Newt will treat it like any other `.md` file in/under `_src`
> and create a `homehead.html` file from it!

In `page-template.html`, edit the section of the example file that
checks whether the `@uri-path` template variable is `string-ci=?` to
`"/index.html"`:

```html
      <div class="row-fluid">
        <!-- Main column -->
        <div id="content" class="span9">
          <!-- To put text only on the home page, check for `uri-path`
               being "/index.html" -->
          @(when (string-ci=? uri-path "/index.html")
            @list{
              <h1>Welcome</h1>
              <p>Here is some text that only goes on the home page,
                because we matched on <code>uri-path</code>
                being <code>/index.html</code>.</p> })
      ....
```

# `.newtrc` settings

## `bootstrap-responsive?` and `bootstrap-minified?`

In `page-template.html`, set the style sheets yourself:

```html
    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="/css/bootstrap-responsive.min.css">
```

## `older/newer-buttons`

In `post-template.html`, set them as you like:

```html
  <footer>
    ...
    <!-- Older/Newer post buttons -->
    <ul class="pager">
      @(when newer-uri
        @list{
          <li class="previous">
            <a href="@newer-uri">&larr; <em>@|newer-title|</em></a>
          </li>})
      @(when older-uri
        @list{
          <li class="next">
            <a href="@older-uri"><em>@|older-title|</em> &rarr;</a>
          </li>})
    </ul>
  </footer>
```

## `favicon`

In `page-template.html`, set it:

```html
    <link rel="icon" href="/favicon.ico">
```

## `google-analytics-account`

In `page-template.html`, set this:

```html
    @google-universal-analytics["UA-xxxxxxxx"] <!-- SET THIS -->
    ...
```

## `disqus-shortname`

In `post-template.html`, change `SHORTNAME` to your actual Disqus
shortname:

```html
    <!-- Disqus comments -->
    <script type="text/javascript">
      var disqus_shortname = 'SHORTNAME';  <!-- CHANGE THIS -->
      ....
```

## `twitter-name` (for Follow button)

In `page-template.html`, change the `href` for your Twitter page, and,
change the "Follow" text:

```html
        <!-- Right column -->
        <div id="right-sidebar" class="span3">
          <!-- `tags/feeds` is a list of tags and feeds -->
          @|tags/feeds|
          <!-- Example of a Twitter follow button -->
          <a href="https://twitter.com/racketlang"
             class="twitter-follow-button"
             data-show-count="false"
             data-lang="en">
            "Follow RacketLang"
          </a>
```

# Conclusion

Of course, the point of Newt leveraging templates is that now you have
more freedom to choose what elements and services you use, as well as
how and where they appear. I'm sorry for the disruption making this
change, but I think this will let people accomplish more of what they
want for the long term.
