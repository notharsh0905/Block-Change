# 18. GOOGLE PLAY RELEASE PLAN

## 18.1 Release artifact

Final release: - signed Android App Bundle (`.aab`).

Do not publish a debug build.

## 18.2 Application identity

Decide and freeze: - package/application ID, - app name, - version
name, - version code, - signing key.

Example package ID: `com.<publisher>.blockchange`

Do not change package ID after production publication.

## 18.3 App icon

Prepare: - Play Store icon, - Android launcher icon, - adaptive icon
foreground/background as appropriate.

Source artwork should be high resolution and clean at small sizes.

## 18.4 Store assets

Prepare: - app icon - feature graphic - phone screenshots - short
description - full description - category - tags/metadata as allowed -
support contact - privacy policy URL - content rating - ads
declaration - data safety declarations - target audience declarations.

## 18.5 Privacy

Because ads/billing/possible SDKs may process information, complete the
Play Console Data Safety form accurately based on the exact production
dependencies.

Never claim "no data is collected" without verifying all SDK behavior.

## 18.6 Testing tracks

Recommended: 1. Local debug 2. Physical device 3. Internal testing track
4. Closed testing if required 5. Production

## 18.7 Release checklist

-   [ ] App name final
-   [ ] Package ID final
-   [ ] Version final
-   [ ] Signing configured
-   [ ] Production ad IDs configured
-   [ ] Test ad IDs absent from release
-   [ ] Remove Ads product configured
-   [ ] Purchase tested
-   [ ] Restore tested
-   [ ] 100 levels validated
-   [ ] Offline behavior tested
-   [ ] Ads tested
-   [ ] Skins tested
-   [ ] Audio tested
-   [ ] Haptics tested
-   [ ] Dark/light theme tested
-   [ ] Color Assist tested
-   [ ] App icon ready
-   [ ] Screenshots ready
-   [ ] Privacy policy ready
-   [ ] Data Safety completed
-   [ ] Content rating completed
-   [ ] AAB built
-   [ ] Internal testing completed
-   [ ] Release crash-free in testing
