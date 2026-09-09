---
name: tossinvest
description: Authenticate with the Toss Securities Open API and query accounts, holdings, buying power, and market prices.
---

# Toss Securities Open API

## Authentication

- Follow the `one-password` skill first (installed at `~/.agents/skills/one-password/SKILL.md`).
- Credentials: item `토스증권 Open API` in the `agents` vault. Extract the exact JSON field labels `client_id` and `client_secret`.
- Pipe this command's output directly into a parser. Never print secrets or tokens or save them to files.

```sh
OP_LOAD_DESKTOP_APP_SETTINGS=false OP_BIOMETRIC_UNLOCK_ENABLED=false \
  ~/.local/bin/op item get '토스증권 Open API' --vault agents --format json </dev/null
```

- Base URL: `https://openapi.tossinvest.com`
- `POST /oauth2/token`: use `Content-Type: application/x-www-form-urlencoded` with URL-encoded `grant_type=client_credentials`, `client_id`, and `client_secret`.
- The response contains `access_token`, `token_type`, and `expires_in` without an envelope. Follow `expires_in` (approximately 24 hours in the verified response).
- **Only one token is valid per client; issuing another immediately invalidates the previous token.** Reuse a valid token when available. No refresh token is provided.
- Register the caller's IP in Toss Securities WTS under Settings → Open API → Allowed IP management.

## Queries

Send `Authorization: Bearer {access_token}` with every query. For asset and order queries, also send `X-Tossinvest-Account: {accountSeq}`, using `accountSeq` from the account list. Listing accounts does not require the account header.

| GET path | Purpose / parameters |
|---|---|
| `/api/v1/accounts` | Brokerage accounts and their `accountSeq` |
| `/api/v1/holdings` | Positions, quantities, average purchase prices, valuations, and profit/loss. Optional: `symbol` |
| `/api/v1/buying-power` | Required: `currency=KRW` or `USD` |
| `/api/v1/prices` | Required: comma-separated `symbols=005930,AAPL`, up to 200 symbols |
| `/api/v1/exchange-rate` | Required: `baseCurrency=USD&quoteCurrency=KRW` |

Successful query data is under `result`. Use six-character stock codes for Korean securities and tickers for US securities.

## Response semantics and errors

- Amounts and quantities are decimal strings; returns are fractional ratios (`0.02` = 2%). `amountAfterCost` and `rateAfterCost` deduct taxes and commissions.
- Holdings totals under `krw` and `usd` are separate currency sums. Aggregate `profitLoss.rate` uses KRW conversion and may differ from USD returns. Isolating FX profit/loss requires acquisition-time data.
- `cashBuyingPower` is cash-based buying power excluding unsettled credit purchases; do not equate it with cash balance or withdrawable funds.
- Read `X-RateLimit-Limit` and `X-RateLimit-Remaining`; honor `Retry-After` on 429. For 401, check token expiry or replacement; for 403, check allowed IPs and permissions.
- A query request does not authorize creating, modifying, or canceling orders.

## Official specifications

Consult the [OpenAPI JSON](https://openapi.tossinvest.com/openapi-docs/latest/openapi.json) for additional endpoints or changed behavior. [llms.txt](https://developers.tossinvest.com/llms.txt) links to the documentation, including realtime WebSocket specifications.
