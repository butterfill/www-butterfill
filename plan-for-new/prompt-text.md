We are working on migrating the old codebase in www-butterfill-old/ to the new version in 
www-butterfill-new/ . There are detailed requirements and instructions in plan-for-new/ . 

We have 
completed phase 2 so far and started phase 3. Task 3.2 has been completed. Another dev has worked on Task 3.3 but done an extremely poor job. Your current task is to re-do Task 3.3 properly. It's not just that the styling fails in every respect—colour, readability, attractiveness, ...; there is also no visible dark mode option.

The site is available at `http://localhost:4321/` (do not `npm run dev`, as your updates will be reflected here.)


---

We are working on an astro+svelte static site using tailwind v3. This is mostly working but we are adding features.

The site is available at `http://localhost:4321/` (do not `npm run dev`, as your updates will be reflected here; just `curl` if you need to check anything.)

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

