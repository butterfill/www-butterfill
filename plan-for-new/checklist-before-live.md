## code

Add links to fulltext md files to `LLM.txt`

## Articles

- [ ] abstracts
- [ ] full text
- [x] pdfs
- [x] bibtex
- [ ] add reference section to md (pandoc on HTML seems to remove it)
- [ ] remove double brackets referencing snafu in HTML?
- [ ] script to build all HTML?
- [ ] github repo per article and links to it

## Talks

- [ ] auto link handouts.butterfill.com

## Teaching

- [x] add all entries
- [ ] move or replicate teaching content from old site (this is not in source, you might have to scrape from butterfill.com (!)). This is just for `https://www.butterfill.com/teaching/joint_action_and_the_emergence.html` and `https://www.butterfill.com/teaching/mindreading_and_joint_action.html`


## LLMs

- [ ] fix llms.txt so that it has the correct content and links.

- [x] Add JSON‑LD to every item page:
 
      Publications: ScholarlyArticle (or Article) with name, author, datePublished, isPartOf (journal/proceedings), identifier/DOI, url, sameAs, abstract, keywords, citation/reference, and license if applicable.
 
      Talks: Event (or EducationalEvent) with name, startDate, location, organizer, about, speaker, recording link, slides as hasPart/encoding.
 
      Courses/Teaching: Course and CourseInstance with name, description, provider, instructor, courseCode, learningResourceType; use CreativeWork for syllabi, lecture notes, and assignments.

- [ ] robots.txt

- [x] enable zotero extension with metadata (see brave, https://www.perplexity.ai/search/i-am-making-a-static-site-usin-cqx6xCfMQLCfjvtXVG0apA)

## Misc

- [ ] fix header links (do I want pages for articles, talks &c or would that replicate? Should I put just a few on the front page---maybe selected writing, talks?)
- [ ] Photo
- [x] Email address
- [ ] sitemap.xml with lastmod accurate in ISO‑8601 
- [ ] git hub repo for astro+svelte source (with brief guide to re-using for your own site)
