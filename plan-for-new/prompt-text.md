We are working on migrating the old codebase in www-butterfill-old/ to the new version in 
www-butterfill-new/ . There are detailed requirements and instructions in plan-for-new/ . 

The site is available at `http://localhost:4321/` (do not `npm run dev`, as your updates will be reflected here.)


---

We are working on an astro+svelte static site using tailwind v3. This is mostly working but we are adding features.

The site is available at `http://localhost:4321/` (do not `npm run dev`, as your updates will be reflected here; just `curl` if you need to check anything.)

The header has 'Butterfill' top left, which is the link to get to the home page. Please add an email icon to the right of 'Butterfill'. Clicking it should pop up a modal. The modal displays my email address, 's.butterfill@warwick.ac.uk' with an icon to copy the address and an icon to launch the user’s email app (mailto: link)


We are working on the article pages which display full text. The single example is `http://localhost:4321/writing/butterfill2025_three/`.  The svelte component you are concerned with is FontSettings 

We have a problem:

1. When the font size changes, the width of the main body of the fulltext does not increase or decrease. This is wrong.  We should aim to make the width change so that as close as possible to 80 characters per line are displayed.

DO NOT WRITE ANY CODE YET. Present your plan, ask any questions you need answers to, and wait for my confirmation. I am interested in learning how to fix the problem myself.

---

There is a document about the command menu in `docs-developers/command-menu.md`. Please read this carefully. Then add a new action to the command menu, 'Home' which should appear as the first item under 'Navigation' except on the home page.

---

We are working on the article pages which display full text. The single example is `http://localhost:4321/writing/butterfill2025_three/` The two svelte components you are concerned with are FontSettings and FootnoteManager. There are some notes on this in `docs-developers/article-fulltext.md` which you should read carefully and update as you make changes. It is very easy to introduce regressions to the positioning of footnotes: please be extremely cautious.

---

I will `npm run dev` so please do not do that. Just let me know when it's time to `npm run dev`.


---

We are working on an astro+svelte static site using tailwind v3. This is mostly working but we are adding features.

The site is available at `http://localhost:4321/` (do not `npm run dev`, as your updates will be reflected here; just `curl` if you need to check anything.)

We are working on the article, teaching and talks pages. 

I want to add a feature: in development mode (`npm run dev`) only, there should be an `open source` button and command menu item. The button should appear left of the `cite` button. Clicking the button should open the page in vs code on a mac where the path to the root of the astro project is `~/Documents/programming/git/www-butterfill/www-butterfill-new`. 


DO NOT WRITE ANY CODE YET. Present your plan, ask any questions you need answers to, and wait for my confirmation. I am interested in learning how to add the feature myself.

---

We are working on an astro+svelte static site using tailwind v3. This is mostly working but we are adding features.

The site is available at `http://localhost:4321/` (do not `npm run dev`, as your updates will be reflected here; just `curl` if you need to check anything.)

The index page contains featured writing only. We would like to add a page, `/writing/`, which lists all writing in exactly the same style as the index page. There should be a link from the index page to the 'Writing' page.

DO NOT WRITE ANY CODE YET. Present your plan, ask any questions you need answers to, and wait for my confirmation. 

---