# ACCT224 Reviewer

A browser-based problem reviewer for ACCT 224 (Corporate Finance 1) — practice problems recreated from the in-class question (ICQ) handouts and Connect textbook quizzes, for Weeks 2 through 8 (Week 1 is concepts-only and intentionally excluded).

**Live site:** enable GitHub Pages for this repo (Settings → Pages → Source: Deploy from a branch → `main` / `/ (root)`), then the reviewer is at:
`https://snowabraxas.github.io/acct224-reviewer/`

## What it does

- Recreates each week's problems with real answer fields you type into and check, worked steps you can reveal, and a "Show formulas" view scoped to just the formulas that part needs.
- Colour-codes each week for quick visual recall.
- Two modes: **Week by week** (follows the course in order, grouped under a Test 1 / Test 2 selector) and **Mixed practice** (shuffles across whichever weeks you pick, with a filter for problems flagged "review again later").
- Lets you flag problems for review and attach free-text notes on what's tripping you up, with a consolidated "My notes" panel.
- Saves your answers, flags and notes in your browser so you don't lose progress between visits. There are no accounts and no sign-in: open the link and start working.

## Structure

Everything lives in a single file, `index.html` — no build step. Open it directly or serve it as a static site.

- CSS custom properties drive the light/dark theme and each week's colour.
- The `P` array holds every problem (given info, answer fields, worked steps).
- `FX` / `FXMAP` hold the formula library and which formulas apply to which problem part.
- `WEEK_NUMS` / `WEEKS` / `TESTS` drive every week-aware piece of the UI, so adding a new week is mostly additive.
- Worksheets are built with `wst()` (tables) and `calc()` (fill-in formula lines). A `{{fN}}` token inside a part's `gq`, or `{{pNfM}}` in a problem's given block, is replaced at render time by that field's own marked input; every other `____` run becomes an unmarked scratch input.
- Test 2 formulas are written linearly in the source (`I ÷ P × 365 ÷ d`, `√( 2 × S × O ÷ C )`, `∛[ … ]`) and `mathify()` renders them at display time as stacked fractions, radicals and superscripts matching the professor's slides. It runs on worksheet lines, steps, notes and the formula panel; calculator keystroke notes and prose are left as they are.

## Adding a new week

1. Add a colour pair (`--wN` / `--wNs`) in all three CSS blocks (light, dark-media-query, `data-theme="dark"`).
2. Add `N` to `WEEK_NUMS`, an entry to `WEEKS`, an overview paragraph to `OVERVIEWS`, and (once Test 1/2 coverage is decided) the week number to the right group in `TESTS`.
3. Add problems to `P` with `w: N`, and any new formulas to `FX` / `FXMAP`.
4. Verify every problem's own correct answer round-trips through the checking logic, and every `FXMAP` entry only references real `FX` keys, before publishing (two small Playwright scripts do this — see project history).

## Data and privacy

Everything you type stays in your own browser's local storage. Nothing is sent anywhere, there is no database behind the page and no account to create, so nobody — including whoever owns this repo — can see another person's answers or notes.

The trade-off is that your work is tied to that browser: clearing site data, switching browsers or using a private window starts you fresh.

`supabase/schema.sql` is kept for reference. It holds the table and Row Level Security policies for an optional signed-in sync mode that is currently switched off.
