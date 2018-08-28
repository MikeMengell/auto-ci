Flow

Run create TF admin project script
    User enters required config info
    Config is saved and encrypted in blackbox


GCP Structure

- Org Root Project (incl. terraform setup)
  - Shared-Pipeline (kubes, concourse)
  - Platform-Infra (for environments)
  - QA
    - App1
    - App2
  - PROD
    - App2
    - App2
