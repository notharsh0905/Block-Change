# 16. TESTING AND QA

## 16.1 Unit tests

Must cover: - color cycle - win condition - bomb neighborhood - freeze
duration - lock duration - chaos timing - pause/resume - timer - star
calculation - level unlocking - level validation - seeded
reproducibility - persistence serialization - skin ownership - purchase
state mapping.

## 16.2 Solvability tests

Every campaign level must be validated in automated tests or a
pre-release validation process.

Required: - 100/100 levels pass. - no invalid tile coordinates. - no
invalid colors. - no impossible target. - no malformed star rules.

## 16.3 Widget tests

Test: - Home - Map - Gameplay HUD - tile tap - Pause - Time Up -
Complete - Shop - Settings - Offline overlay.

## 16.4 Integration tests

Test: - fresh install - startup online - startup offline - internet lost
in Home - internet lost in Map - internet lost during gameplay -
reconnect and Retry - background/resume online - background/resume
offline - rewarded ad success/failure - purchase
success/cancel/pending/failure/restore.

## 16.5 Physical-device testing

At minimum: - one real Android phone, - one additional Android
device/emulator configuration, - different screen sizes, - slow
network, - Wi-Fi, - mobile data.

## 16.6 Network testing matrix

Test: 1. Wi-Fi on. 2. Mobile data on. 3. Both off. 4. Wi-Fi disabled
during level. 5. Mobile data disabled during level. 6. Airplane mode
during level. 7. Network returns during offline overlay. 8. Network
flaps rapidly. 9. App backgrounded while offline. 10. App restarted
while offline.

## 16.7 Ad QA

Verify: - test IDs in debug, - banner placement, - interstitial
frequency, - rewarded completion callback, - no reward after
failed/cancelled ad, - Remove Ads hides banner, - Remove Ads blocks
interstitial, - rewarded still works if configured to remain.

## 16.8 Purchase QA

Using Google Play test environment: - purchase, - cancel, - pending, -
restore, - reinstall, - new device/test account, - Remove Ads state.

## 16.9 Performance QA

Check: - 60 FPS target, - no frame spikes from normal tile actions, -
8x8 board, - special tile effects, - level completion particles, -
memory usage, - repeated level restart.

## 16.10 Regression policy

Every fixed gameplay bug should receive a regression test when
practical.

## 16.11 Release blocker examples

Do not ship if: - any campaign level is impossible, - game continues
while offline, - timer continues while paused, - production build uses
test ads, - test build uses production ads, - Remove Ads does not
restore, - purchase state can be trivially corrupted, - critical crash
exists, - progress is lost, - board is obscured by banner, - debug tools
are accessible to normal players.
