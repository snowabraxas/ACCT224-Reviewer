# ACCT224 Reviewer

A browser-based problem reviewer for ACCT 224 (Corporate Finance 1) — practice problems recreated from the in-class question (ICQ) handouts and Connect textbook quizzes, for Weeks 2 through 8 (Week 1 is concepts-only and intentionally excluded).

**Live site:** enable GitHub Pages for this repo (Settings → Pages → Source: Deploy from a branch → `main` / `/ (root)`), then the reviewer is at:
`https://snowabraxas.github.io/acct224-reviewer/`

## What it does

- Recreates each week's problems with real answer fields you type into and check, worked steps you can reveal, and a "Show formulas" view scoped to just the formulas that part needs.
- Colour-codes each week for quick visual recall.
- Two modes: **Week by week** (follows the course in order, grouped under a Test 1 / Test 2 selector) and **Mixed practice** (shuffles across whichever weeks you pick, with a filter for problems flagged "review again later").
- Lets you flag problems for review and attach free-text notes on what's tripping you up, with a consolidated "My notes" panel.
- Saves your answers, flags and notes so you don't lose progress — backed by Supabase so it follows you across devices and browsers once you sign in (falls back to this browser only if you're not signed in or Supabase isn't configured).

## Structure

Everything lives in a single file, `index.html` — no build step. Open it directly or serve it as a static site.

- CSS custom properties drive the light/dark theme and each week's colour.
- The `P` array holds every problem (given info, answer fields, worked steps).
- `FX` / `FXMAP` hold the formula library and which formulas apply to which problem part.
- `WEEK_NUMS` / `WEEKS` / `TESTS` drive every week-aware piece of the UI, so adding a new week is mostly additive.
- `SUPABASE_URL` / `SUPABASE_KEY` near the top of the script point at the Supabase project (the key is the public **anon/publishable** key, safe to be public — see `supabase/schema.sql` for the table and Row Level Security policies it relies on). If a fork doesn't set up its own Supabase project, the page just falls back to this-browser-only storage.

## Adding a new week

1. Add a colour pair (`--wN` / `--wNs`) in all three CSS blocks (light, dark-media-query, `data-theme="dark"`).
2. Add `N` to `WEEK_NUMS`, an entry to `WEEKS`, an overview paragraph to `OVERVIEWS`, and (once Test 1/2 coverage is decided) the week number to the right group in `TESTS`.
3. Add problems to `P` with `w: N`, and any new formulas to `FX` / `FXMAP`.
4. Verify every problem's own correct answer round-trips through the checking logic, and every `FXMAP` entry only references real `FX` keys, before publishing (two small Playwright scripts do this — see project history).

## Data and privacy

Sign-in is Google OAuth through Supabase Auth. No email is sent by this app, which sidesteps Supabase's built-in email service (it only delivers to addresses inside the project's own organisation, and caps at ~2 per hour).

Each signed-in user's answers, flags and notes are stored in Supabase under their own row, protected by Row Level Security — nobody else (including the repo owner) can read another user's saved progress.
