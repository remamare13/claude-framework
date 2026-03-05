# Security Rules — MANDATORY

These rules protect sensitive data. Violations can expose client data, credentials, or system access.

## Secrets & Credentials

1. **NEVER hardcode secrets** — API keys, tokens, passwords, private keys belong ONLY in `.env`
2. **NEVER commit secrets** — `.env`, `*.pem`, `*.key`, `credentials.*` must be in `.gitignore`
3. **NEVER log secrets** — no tokens, passwords, or API keys in log output
4. **NEVER expose secrets to frontend** — the browser/client must NEVER receive:
   - API keys or tokens (OpenAI, Anthropic, OpenClaw, etc.)
   - JWT signing secrets
   - Database connection strings
   - Internal service URLs or ports that should not be public
   - Environment variables containing secrets

## Frontend / Client-Side

5. **NEVER send sensitive data to the browser** — API responses must NOT include:
   - Server-side secrets or config
   - Other users' data
   - Internal system state (stack traces, DB queries, file paths)
   - PII of other clients/users
6. **NEVER trust client input** — validate and sanitize ALL input from the browser
7. **API responses should contain ONLY what the UI needs** — no extra fields "just in case"
8. **Auth tokens (JWT) should be httpOnly cookies or carefully managed** — never stored in localStorage if avoidable

## PII (Personally Identifiable Information)

9. **NEVER log PII** — no names, EMSO, tax numbers, addresses, phone numbers in logs
10. **Use anonymizer** — `src/utils/anonymizer.js` for any logging that might contain client data
11. **PII stays in the database** — no PII in memory files, CLAUDE.md, git history, or error messages
12. **Minimize PII in API responses** — return only fields the UI actually displays

## Database

13. **ALWAYS use parameterized queries** — `db.prepare('SELECT * FROM x WHERE id = ?').get(id)`
14. **NEVER concatenate user input into SQL** — no template literals in queries
15. **NEVER expose raw DB errors to the client** — catch and return generic error messages

## Network

16. **Auth middleware on ALL non-public endpoints** — only `/health` and `/api/auth/login` are public
17. **Rate limiting on auth endpoints** — prevent brute force
18. **CORS configured properly** — not `*` in production
19. **Helmet headers enabled** — XSS protection, content-type sniffing, etc.

## Code Review Triggers

If you see ANY of these patterns, flag as **HIGH severity**:
- `process.env.` in a file served to the client
- API response containing `secret`, `token`, `key`, `password` fields
- `console.log` with user data
- SQL query built with template literals or string concatenation
- `res.json(error)` or `res.json(err.stack)` — exposes internals
- `cors({ origin: '*' })` in production code
- Missing `authenticateToken` on a non-public route
