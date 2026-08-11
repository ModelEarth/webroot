---
name: push-vercel-oauth-env
description: Push the social-login OAuth client id/secret pairs from docker/.env into a linked Vercel project's Environment Variables, using chat/scripts/vercel-env.config.json for the public shape (which vars, which environment). Use when the user asks to sync/push/update OAuth or social-auth keys to Vercel. Never prints secret values.
---

# Push OAuth env vars to Vercel

This wraps `chat/scripts/push-oauth-env-to-vercel.sh`. The script is the
deterministic part (loops over the config, pipes secret values straight into
`vercel env add`, never echoes them). Your job is the judgment calls around it.

## Steps

1. **Check prerequisites** before doing anything else:
   - `command -v vercel` — if missing, tell the user to run `npm i -g vercel` and stop.
   - `command -v jq` — if missing, tell the user to run `brew install jq` and stop.
   - Ask the user (if not already clear from context) which local directory is
     the linked Vercel project — the one where they ran `vercel link`. Check
     `<dir>/.vercel/project.json` exists. If not, tell them to run `vercel link`
     there first and stop.

2. **Confirm scope before running anything that writes to Vercel.** This
   modifies live environment variables on a shared/external system, so always
   state plainly and get explicit confirmation:
   - which environment (`production`, `preview`, or `development` — read the
     default from `vercel-env.config.json`'s `environment` field, but ask if
     the user hasn't said)
   - that this will overwrite any existing values for the same keys in that
     environment (the script does `vercel env rm` before `add`)
   - Never print or repeat back the secret values themselves — only key names.

3. **Read `chat/scripts/vercel-env.config.json` to know what will be pushed**
   (it's fine to show the user this file — it has no secrets, only key names
   and the environment target). If the user wants to add/remove a provider or
   change the environment, edit this config file directly rather than the
   script.

4. **Run the script** from the linked project directory:
   ```
   chat/scripts/push-oauth-env-to-vercel.sh [path-to-config] [environment-override]
   ```
   Both arguments are optional — defaults come from the config file.

5. **Report results using only what the script printed** (key names and
   skip/push status) — do not go looking for the actual values in `docker/.env`
   to "double check" as part of this flow.

6. **Remind the user to trigger a redeploy** — Vercel does not rebuild
   automatically when env vars change.

## Adding a new provider

Edit `chat/scripts/vercel-env.config.json`'s `vars` array — add
`{ "source": "<KEY_IN_DOTENV>", "target": "<KEY_VERCEL_SHOULD_HAVE>" }`. Check
`chat/lib/auth/social-providers.ts` first for the exact var name the app code
actually reads — `source` and `target` differ when `docker/.env`'s naming
doesn't match (e.g. Facebook: `.env` has `FACEBOOK_APP_ID` /
`FACEBOOK_APP_SECRET`, the app reads `FACEBOOK_CLIENT_ID` /
`FACEBOOK_CLIENT_SECRET`).
