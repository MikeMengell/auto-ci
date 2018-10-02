resource "google_project" "auto-ci" {
  name = "${var.project_name}"
  project_id = "${var.project_id}"
  billing_account = "${var.billing_account}"
  org_id     = "${var.org_id}"
}

