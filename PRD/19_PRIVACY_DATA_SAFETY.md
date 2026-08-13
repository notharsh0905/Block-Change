# 19. PRIVACY AND DATA SAFETY

## 19.1 Architecture

The game itself has: - no account, - no login, - no custom backend, - no
user profile database, - no cloud save.

## 19.2 Third-party services

The production app may include: - Google Mobile Ads - Google Play
Billing - optional crash reporting/analytics only if explicitly
approved.

Each service has its own data handling.

## 19.3 Privacy policy

Before Play Store release, publish a privacy policy describing: - what
the game itself stores locally, - what third-party SDKs may
collect/process, - advertising, - purchase processing, -
connectivity/network information, - diagnostics if enabled, - contact
information, - retention/deletion approach where applicable.

## 19.4 Data Safety

Complete Google Play's Data Safety form based on the final dependency
versions and their documented behavior.

Do not guess.

## 19.5 Analytics decision

Do not add analytics/crash reporting by default merely because it is
useful.

If added later, update: - PRD, - dependency list, - privacy policy, -
Data Safety declarations, - release checklist.
