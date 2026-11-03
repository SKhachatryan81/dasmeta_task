resource "google_monitoring_uptime_check_config" "podinfo" {
  display_name = "podinfo /healthz"
  timeout      = "10s"
  period       = "60s"

  http_check {
    path = "/healthz"
    port = 80
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = "podinfo.${module.network.ingress_ip}.sslip.io"
    }
  }
}

resource "google_monitoring_alert_policy" "podinfo_down" {
  display_name = "podinfo is down (external check)"
  combiner     = "OR"

  conditions {
    display_name = "Uptime check failing"
    condition_threshold {
      filter = join(" AND ", [
        "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\"",
        "resource.type=\"uptime_url\"",
        "metric.label.check_id=\"${google_monitoring_uptime_check_config.podinfo.uptime_check_id}\"",
      ])
      comparison      = "COMPARISON_GT"
      threshold_value = 1
      duration        = "120s"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.label.host"]
      }
    }
  }

  notification_channels = [data.google_monitoring_notification_channel.slack.name]
}

data "google_monitoring_notification_channel" "slack" {
  display_name = "alerts"
}