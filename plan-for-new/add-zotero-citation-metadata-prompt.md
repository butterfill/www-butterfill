# url

- https://aistudio.google.com/prompts/1-M0p7CmeaSSqam3wrwJVMyD3_AWCjM4E

# notes

Attempted to start this with qwen CLI but I don’t think qwen has the chops for this.
Switched to gemini but gave it qwen’s plan as a start. Result was much better.

Implemented with claude in rovodev. Experience:
  - Claude wrote lots of temporary tests. Should have requested a plan for writing tests to have permanent tests for this part. (Or just asked gemini for step 1).
  - Claude was super careful checking that things worked at each stage. Not sure whether this is just claude vs qwen or whether the plan helped.
  - took ~3M tokens in rovodev


# prompt
We are working on an astro+svelte static site using tailwind v3. This is mostly working but we are adding features.

The site is available at `http://localhost:4321/` (do not `npm run dev`, as your updates will be reflected here; just `curl` if you need to check anything.)

On the pages for individual articles, eg `http://localhost:4321/writing/collective_goals/`, we want to add metadata that will allow users of the Zotero we extension to add citations easily. 

Your task is to come up with a detailed plan for implementing this feature, considering potential risks.  Include a definition of done. Ask any questions you need answers to before writing the final plan. 

There is a draft plan included below. Please review this for inspiration. I do want something substantially more detailed.

Use the guide to enabling support below. Note that this does not cover book chapters etc. You will need to check https://www.zotero.org/support/dev/exposing_metadata for further instructions. Please include details about metadata in your plan.

You will need to examine the codebase carefully to see the available metadata and how pdfs are linked, and so one. Please think through what you need to know and check for answers in the code.

Please also check the names in the bibtex entries in articles for edge cases. Here are some examples:
   1. Multiple authors: Separated by " and " (e.g., "Stephen A. Butterfill and Corrado Sinigaglia")
   2. Complex names with accents: LaTeX escape sequences (e.g., "Vigan{\`o}, Luca")
   3. Names with protective braces: "{della Gatta}, Francesco"
   4. Already formatted names: "Butterfill, Stephen A." (some BibTeX entries have this format)
   5. Multiple complex authors: Mixed formats in a single entry

Note that we already have code that parses bibtex. Be sure that we do not replicate that.

# Steps to Enable Zotero Support

## 1. Add Citation Metadata Tags

Zotero detects metadata from standard meta tags in the HTML head section. The most universal format supported is Highwire Press tags and Dublin Core tags, but Zotero mainly looks for tags like:

citation_title

citation_author (use multiple tags for multiple authors)

citation_publication_date

citation_journal_title

citation_volume

citation_issue

citation_firstpage

citation_lastpage

citation_doi

citation_pdf_url

Example snippet for your Astro page (in the <head> of your HTML):

```xml
<meta name="citation_title" content="Your Article Title">
<meta name="citation_author" content="Doe, Jane">
<meta name="citation_publication_date" content="2025-08-18">
<meta name="citation_journal_title" content="My Personal Journal">
<meta name="citation_pdf_url" content="https://example.com/path-to-your-article.pdf">
<meta name="citation_doi" content="10.1234/example.doi">
```


Full list and documentation: https://www.zotero.org/support/dev/exposing_metadata

## 2. Provide Links to PDFs

Including a citation_pdf_url tag ensures Zotero can download the PDF automatically if available.

## 3. Structured Author Information
For best results, authors in the metadata should be listed as "Lastname, Firstname".


<draft-plan>

  Plan for Implementing Zotero Support for Writing Articles

  OverviewAdd metadata tags to individual writing pages that will allow Zotero browser extension to automatically detect and import citations.

  Author Name Edge Cases Identified
   1. Standard format: "Firstname Lastname" (e.g., "Stephen A. Butterfill")
   2. Multiple authors: Separated by " and " (e.g., "Stephen A. Butterfill and Corrado Sinigaglia")3. Complex names with accents: LaTeX escape
      sequences (e.g., "Vigan{\`o}, Luca")
   4. Names with protective braces: "{della Gatta}, Francesco"
   5. Already formatted names: "Butterfill, Stephen A." (some BibTeX entries have this format)
   6. Multiple complex authors: Mixed formats in a single entry

  Implementation Details

  ###1. Parse BibTeX Data
   - Use existing parseBibtex function from src/lib/citation-utils.ts to extract citation metadata
   - Extract required fields for Zotero based on publication type:

  For Journal Articles:
   - citation_title (from BibTeX title)- citation_author (from BibTeX author, converted to "Lastname, Firstname" format)
   - citation_publication_date (from BibTeX year field)
   - citation_journal_title (from BibTeX journal field)- citation_volume (from BibTeX volume field)- citation_issue (from BibTeX number field)-
     citation_firstpage and citation_lastpage (parsed from BibTeX pages field)- citation_doi (from BibTeX doi field)
   - citation_pdf_url (from entry.pdfUrl field)

  For Book Chapters:
   - citation_title (from BibTeX title)
   - citation_author (from BibTeX author, converted to "Lastname, Firstname" format)- citation_publication_date (from BibTeX year field)
   - citation_book_title (from BibTeX booktitle field)- citation_firstpage and citation_lastpage (parsed from BibTeX pages field)- citation_doi
     (from BibTeX doi field)
   - citation_pdf_url (from entry.pdfUrl field)
   - citation_editor (from BibTeX editor field, if present)

  ###2. Author Name Formatting
   - Convert author names from various formats to "Lastname, Firstname" format
   - Handle multiple authors separated by " and "- Process LaTeX accents and special characters
   - Handle protective braces in names
   - Maintain existing comma-separated format when already correct### 3. Page Range Parsing- Parse pages field (e.g., "1-29", "53--60",
     "123–148") to extract first and last page
   - Handle different dash formats (hyphen, en-dash, em-dash)

  4. Add Metadata to Page Head
   - Modify src/layouts/BaseLayout.astro to accept metadata props
   - Add conditional rendering of Zotero meta tags in the <head> section- Only include tags with non-empty values- Use repeated meta tags for
     authors/editors rather than semicolon-separated format### 5. Page Integration- Update src/pages/writing/[...slug].astro to:
     - Parse BibTeX data using existing utilities - Generate formatted metadata  - Pass metadata to BaseLayout## Technical Implementation Steps

  Step1: Update BaseLayout to Accept Metadata
   - Add metadata interface to BaseLayout props
   - Add conditional meta tag rendering in head section

  Step 2: Create Author Name Processing Utility- Create a function to convert author names to "Lastname, Firstname" format- Handle edge cases 
  identified above
   - Process multiple authors correctly

  Step 3: Update writing page template- Import citation utilities and new author processing utility
   - Parse BibTeX data
   - Format author names correctly
   - Extract and format all required fields based on publication type- Pass metadata to BaseLayout

  Step4: Test Implementation- Verify meta tags appear correctly in page source- Test with Zotero browser extension- Validate different content 
  types (journal articles, book chapters, etc.)- Test all identified edge cases## Risk Assessment1. Performance Impact: Parsing BibTeX on every
   page request could add overhead - Mitigation: Parsing happens at build time, not runtime2. Data Quality Issues: Inconsistent BibTeX 
  formatting could cause parsing errors - Mitigation: Existing parsing utilities already handle most edge cases - Additional mitigation: Add 
  robust error handling for author name processing3. Incomplete Metadata: Some entries may be missing required fields
      - Mitigation: Only render meta tags for available fields

   4. Author Name Parsing Complexity: Complex author names may not parse correctly   - Mitigation: Implement comprehensive parsing with fallbacks
      and thorough testing

   5. Page Range Parsing: Different dash formats may not parse correctly   - Mitigation: Normalize different dash formats before parsing

   6. Publication Type Detection: Incorrectly identifying journal articles vs book chapters
      - Mitigation: Use presence of journal field for journal articles and booktitle field for book chapters

  Definition of Done

   1. Individual writing pages contain appropriate Zotero meta tags in head section
   2. Meta tags include all available citation information from BibTeX and frontmatter
   3. Author names are formatted as "Lastname, Firstname" in all cases
   4. PDF URLs are correctly referenced when available
   5. Only non-empty meta tags are rendered
   6. Implementation works with Zotero browser extension7. No performance degradation on page load
   8. Code follows existing project patterns and conventions9. All identified author name edge cases are handled correctly
   10. Page range parsing works for all identified formats
   11. Correct metadata fields are used for journal articles vs book chapters
   12. Multiple authors are represented as repeated meta tags

</draft-plan>