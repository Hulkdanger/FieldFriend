# FieldFriend - Your Personalized Locust Sighting Platform

**Here's a demo web-version link to my app:** <https://pest-app-gn2dxa.flutterflow.app/>

## 1) Problem & Outcome
- **Problem:** Locust swarms destroy crops worldwide. I've witnessed firsthand their devastation at my ancestral farm. Data exists but it's hard for farmers to use in real time.
- **Outcome:** I've made a free app that shows **nearby risk**, aggregates official + community reports, and explains **_why_** the risk is what it is. This app is made to make the data more accesible, so that farmers can have preparation time before swarmd=s come. 

**Flow:** ArcGIS FeatureServer → Cloud Function `ingestLocustV2` → Firestore (TTL) → Flutter app (web/iOS/Android) → optional user reports.

## 2) Features
- Risk score with **explain-why** panel (behavior, maturity, recency).
- Google-Map markers with info windows.
- **Time filters** (7/30/60/90 days) and **report filtering**.
- Anonymous post flow with basic moderation flags.
- Scheduled ingest + **idempotent upserts**; deletes stale docs via TTL.

## 3) Tech Stack:
1. Flutterflow was used or UI editing and rapid prototyping.
2. The main features of the app, listed below, were hand-coded and inserted as custom widgets. Here's the custom-coded features:  
    a) custom marker map with info windows  
    b) a reports list with swarm information and filtering options  
    c) a posting feature, in which users can upload their own swarm sightings to the map and reports list
3. Firebase was used for the back-end database of locust swarm information. Also used for Functions Gen-2 (Node 18) and scheduled jobs.

## 4) Risk Algorithim:
A custom risk algorithim was used to determine a user's risk given their locust swarms near their area. Here's how it was implemented: 

`Risk = 100 × 2^(-distance/100) × 2^(-days/30) × ∛(wₘ × wᵦ × wᵦᵣ)`

Here's the given weights for each data type:

| Maturity (w<sub>m</sub>) | Weight | Behaviour (w<sub>β</sub>) | Weight | Breeding (w<sub>βr</sub>) | Weight |
|:-------------------------|------:|:---------------------------|------:|:--------------------------|------:|
| Mature                   | 1.00  | Swarms                     | 1.00  | Laying                    | 1.00  |
| Hopper/Nymph             | 0.80  | Groups                     | 0.65  | Copulating                | 0.85  |
| Immature                 | 0.70  | Unknown/N/A                | 0.60  | N/A                       | 0.70  |
| Unknown/N/A              | 0.60  | Scattered/Isolated         | 0.40  | —                         | —     |

## 5) Data Sources

### A) FAO Desert Locust Hub (ArcGIS FeatureServer)
- **What:** Official desert-locust situation data published via ArcGIS FeatureServer.
- **Fields consumed (typical):**
  - `id`, `latitude`, `longitude`, `observationDate`
  - `species`, `maturity`, `behaviour` (e.g., Swarms/Groups/Isolated)
  - `country`, `admin`, `notes`
- **Refresh:** Pulled by Cloud Function on a schedule; upserts new/changed records and TTL-removes stale items.
- **Use & attribution:** Used under FAO/ArcGIS terms; attribution is included in-app.
- **Notes:** The app stores a minimized subset of fields for display & risk scoring; raw endpoints/keys are configured via environment variables.

  PS: Check out the lib folder for all the custom code widgets, actions, and functions!


