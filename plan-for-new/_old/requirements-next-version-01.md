Thinking of migrating my static website from docpad to a new system and making some improvements. 

## build
- move from docpad to a more modern static site builder; could be custom (I like vite and sveltekit but happy to consider alternatives; no react.js unless there is a very good reason for it) UPDATE: have chosen astro
- we will write code to convert existing content files into new formats
- my publications list needs to be based on a yaml file which, for each publication, contains the bibtex entry plus any additional links or info
- the lists of my lectures and talks likewise need to be built from yaml files

## functionality
- retain all existing functions

## improvements

### LLMs
- build process must include llms.txt
- each content page should have a `copy for chat` button which creates text suitable for pasting into a chat

### writing
- we will add markdown sources for each publication (in addition to pdf) so that the page for the publication can display the full text. 
- We will include the full text for each paper (or a link) in llms.txt
- the files for each publication (e.g. `childrens_selective_learning_from_others.html.jade`) may include a `bibtex` key; where they do so, the `title`, `authors`, etc keys are not necessary and the details will be extracted from the value of the bibtex key.

### command pallet
- allows you to navigate the site
- when on the page for a paper, includes options to download the paper in various formats

### styling
- must work on desktop and mobile
- make it more readable
- should look slightly better overall but not too different and not flashy
- low key, highly readable; somewhat nerdy
- the `zed.dev` website shows the style we would like


## approach
In migrating the existing site, we may write some code to transform existing files into a new format.  Manual updates should be as limited as possible.

In addition to using astro, we may write some code to pre-process some of the source files. For example, it may be better to preprocess the files for each publication (e.g. `childrens_selective_learning_from_others.html.jade`) rather than attempting to do this within astro (I am not sure).