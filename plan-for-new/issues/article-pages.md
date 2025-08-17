# update

What follows is wrong: use pandoc for latex-> HTML to display fulltext. (see `writing2/plural-aggregate-reductive/`).

Generate markdown separately for LLMS.txt


# 1. basics

Each publication should have links for viewing HTML full text (where available) and downloading PDF (where available) and markdown (where available) on both the main page and on the page for that publication.

1. [x] pdf links
2. [ ] md links
3. [ ] HTML full text view


# 2. additional

1. [ ] HTML content is rendered as source code. See, for example, http://localhost:4321/writing/joint_action_development/

## Plan for displaying full text and downloading markdown

`.tex` source -> `rmx-convert.js html` -> add to article content page as HTML

### build script
For each article content page
  * remove unwanted frontmatter fields (e.g. pdfURL)
  * convert the HTML to md
  * optionally apply some cleaning steps
  * copy the result into `public/`
  * set `mdUrl` in frontmatter


### required modifications to `rmx-convert.js` 

2. [ ] I want to convert latex source to markdown with rmx-convert.js. This is nearly there. I just have a problem with `\label{}` and `\ref{}`. To fix this: modify `rmx-convert.js` so that (i) it makes a pass through to read the `\label{...}` commands and associates them with sections or footnote numbers (remember that this can be \footnote or \footnotetext); the corresponding map is added to the xref code so that `\ref{}` to a label is resolved correctly. (Attempt to resolve to a label before resolving to anything else.)

3. [ ] we also need to process (i) latex comments (maybe also njk comments first?); and (ii) \begin{abstract}

