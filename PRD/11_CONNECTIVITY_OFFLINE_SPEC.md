# 11. CONNECTIVITY AND OFFLINE SPECIFICATION

## 11.1 Hard requirement

Block Change must not permit gameplay without an active internet
connection.

This rule applies: - at startup, - after returning from background, -
while on Home, - while on Level Map, - during gameplay, - after
reconnecting, - when entering ad/purchase flows where network is
required.

## 11.2 Important technical clarification

There is no Block Change custom backend.

Therefore: - do not implement a fake "server connection"; - do not
create a custom API merely to satisfy this requirement; - use network
connectivity + lightweight internet reachability checks as appropriate.

Connectivity interface availability does not always prove internet
access, so use a suitable reachability strategy.

## 11.3 Startup

Startup: 1. initialize app, 2. initialize local storage, 3. initialize
required services, 4. check connectivity/reachability, 5. if online -\>
Home, 6. if offline -\> Offline Blocking state.

## 11.4 Loss while playing

When the app detects loss: 1. stop/pause timer, 2. stop chaos, 3.
disable tile input, 4. pause relevant animations, 5. pause/duck gameplay
audio, 6. show blocking overlay, 7. prevent level completion from being
accepted while offline if completion occurs after loss, 8. do not allow
bypass.

## 11.5 Offline overlay

Title: No Internet Connection

Body: Block Change requires an internet connection. Please turn on Wi‑Fi
or mobile data to continue.

Button: Retry

## 11.6 Retry

Retry must: - perform a fresh check, - not merely assume connectivity is
restored.

If online: - dismiss overlay, - restore safe paused state, - require
explicit resume if the user was in gameplay.

If offline: - remain blocked.

## 11.7 App background/resume

On resume: - re-check connectivity before restoring gameplay. - If
offline, show blocking state. - If online, restore the paused state.

## 11.8 Offline settings

Recommended: - allow the user to open Settings and view local
configuration, - do not allow gameplay.

## 11.9 No bypass

Do not provide: - hidden skip button, - cached "continue anyway"
button, - debug bypass in release, - offline grace period.

## 11.10 Connectivity race conditions

Guard against: - duplicate listeners, - multiple overlays, - repeated
initialization, - rapid online/offline changes, - stale async checks.

Connectivity state must be centralized.
