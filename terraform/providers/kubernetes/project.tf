resource "google_project" "auto-ci" {
  name = "${var.name}"
  project_id = "${var.projectid}"
  billing_account = "${var.billing_account}"
  org_id     = "${var.org_id}"
}

