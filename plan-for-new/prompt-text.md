We are working on migrating the old codebase in www-butterfill-old/ to the new version in 
www-butterfill-new/ . There are detailed requirements and instructions in plan-for-new/ . 

We have 
completed phase 2 so far and started phase 3. Task 3.2 has been completed. Another dev has worked on Task 3.3 but done an extremely poor job. Your current task is to re-do Task 3.3 properly. It's not just that the styling fails in every respect—colour, readability, attractiveness, ...; there is also no visible dark mode option.

The site is available at `http://localhost:4321/` (do not `npm run dev`, as your updates will be reflected here.)


---

We are working on an astro+svelte static site using tailwind v3. This is mostly working but we are adding features.

The site is available at `http://localhost:4321/` (do not `npm run dev`, as your updates will be reflected here; just `curl` if you need to check anything.)

We are working on the article pages which display full text. The single example is `http://localhost:4321/writing/butterfill2025_three/` The two svelte components you are concerned with are FontSettings and FootnoteManager. There are some notes on this in `docs-developers/article-fulltext.md` which you should read carefully and update as you make changes. It is very easy to introduce regressions to the positioning of footnotes: please be extremely cautious.

We have a problems:

1. When footnote texts potentially overlap because the footnote marks are close together (e.g. footnotes 1-3 in this document), the vertical space between the footnotes is too large. I asked another dev to solve this but they created overlapping footnote texts! Please think carefully about how to get the vertical spacing between potentially overlapping footnotes identical to the spacing between two paragraphs in the main text.

DO NOT WRITE ANY CODE YET. Present your plan, ask any questions you need answers to, and wait for my confirmation. I am interested in learning how to fix the problem myself.

---

There is a document about the command menu in `docs-developers/command-menu.md`. Please read this carefully. Then add a new action to the command menu, 'Home' which should appear as the first item under 'Navigation' except on the home page.

---


I will `npm run dev` so please do not do that. Just let me know when it's time to `npm run dev`.

