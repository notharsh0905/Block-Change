# 10. ADMOB AND MONETIZATION

## 10.1 Ad service

Centralize ad behavior in `AdService`.

Responsibilities: - initialization, - test/prod configuration, - banner
lifecycle, - interstitial loading/showing, - rewarded loading/showing, -
callbacks, - disposal, - Remove Ads gating.

UI widgets should not contain raw ad SDK orchestration.

## 10.2 Banner

Placement: - bottom area, - outside gameplay board, - responsive to safe
area.

Rules: - never cover board, - never cover buttons, - hide when Remove
Ads is active, - handle loading/failure gracefully.

## 10.3 Interstitial

Rules: - never during active gameplay, - never immediately after app
launch, - never while the player is interacting with the board, -
frequency capped, - show only at natural transition points.

Recommended initial policy: - first interstitial only after the player
has completed several levels, - then roughly every 3 completed levels, -
enforce a time/frequency cooldown.

Do not hardcode the final frequency until testing.

## 10.4 Rewarded

Rewarded ads are always user-initiated.

Primary reward: +15 seconds after Time Up.

Secondary candidate: permanent cosmetic skin unlock.

Reward must only be granted from the verified reward callback.

## 10.5 Remove Ads

One-time product: `remove_ads`

Purchase removes: - banner, - interstitial.

Rewarded remains optional unless explicitly disabled.

## 10.6 Purchase state

Possible states: - unknown - not owned - purchased - pending -
restored - unavailable - error.

UI must not permanently mark Remove Ads purchased solely from a local
boolean without checking purchase state when appropriate.

## 10.7 Purchase restore

Provide Restore Purchases in Settings and/or Shop.

Use the platform billing API to restore entitlement.

## 10.8 Pricing

Price is configured in Google Play Console and returned as localized
data.

Do not embed "₹149" as a hardcoded source string.

## 10.9 Testing

Use Google test ad units in development.

Use Play Billing test accounts/testing tracks for purchases.

Never click live ads.

## 10.10 Ad failure

If an ad fails: - do not crash, - do not block the player from normal
gameplay, - do not falsely say the user watched an ad, - show a friendly
retry/continue path.

If rewarded ad fails, no reward is granted.
