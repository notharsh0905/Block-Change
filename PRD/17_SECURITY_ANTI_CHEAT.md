# 17. SECURITY AND ANTI-CHEAT

## 17.1 Scope

Because the game has no backend, server-grade anti-cheat is impossible.

The objective is: - prevent casual exploitation, - avoid accidental
reward duplication, - prevent obvious timer abuse, - protect purchase
state as much as possible through platform APIs, - ensure gameplay
integrity.

## 17.2 Internet enforcement

If internet disappears: - gameplay blocks, - timer pauses, - chaos
pauses, - tile input disabled.

This prevents a user from intentionally disconnecting to play outside
the required online environment.

## 17.3 System clock

Do not use only `DateTime.now()` deltas for active timers.

Prefer monotonic elapsed timing.

System clock changes should not grant extra gameplay time.

## 17.4 App restart

Do not save arbitrary active board states unless the design explicitly
supports it.

Completed progress should be saved immediately after legitimate
completion.

## 17.5 Rewarded ads

Only reward after SDK success callback.

Prevent: - multiple reward callbacks, - reward on ad load, - reward on
ad open, - reward after cancellation.

Use an idempotent reward transaction in the client.

## 17.6 Purchase

Do not trust an arbitrary UI toggle.

Use billing APIs and purchase status.

A local cache may be used for UX but must be reconciled with platform
purchase information.

## 17.7 Debug bypass

Developer-only bypasses may exist during development but: - must be
compile/config gated, - must not be accessible in release, - must be
tested as absent in production.

## 17.8 Reality check

A technically skilled person can modify an APK, patch local data, or
manipulate a client-only game.

Without a backend, this cannot be completely prevented.

Do not build unnecessary complexity pretending client-side anti-cheat
can provide server-level security.
