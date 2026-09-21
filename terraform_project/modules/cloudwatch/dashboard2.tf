resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      # ECS CPU
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title = "ECS CPU Utilization"

          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              var.ecs_cluster_name,
              "ServiceName",
              var.ecs_service_name
            ]
          ]

          stat   = "Average"
          period = 300
          region = var.aws_region
        }
      },

      # ECS Memory
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title = "ECS Memory Utilization"

          metrics = [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              var.ecs_cluster_name,
              "ServiceName",
              var.ecs_service_name
            ]
          ]

          stat   = "Average"
          period = 300
          region = var.aws_region
        }
      },

      # ALB Request Count
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title = "ALB Request Count"

          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              var.alb_arn_suffix
            ]
          ]

          stat   = "Sum"
          period = 300
          region = var.aws_region
        }
      },

      # ALB Response Time
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title = "ALB Response Time"

          metrics = [
            [
              "AWS/ApplicationELB",
              "TargetResponseTime",
              "LoadBalancer",
              var.alb_arn_suffix
            ]
          ]

          stat   = "Average"
          period = 300
          region = var.aws_region
        }
      },

      # ALB 5XX Errors
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6

        properties = {
          title = "ALB 5XX Errors"

          metrics = [
            [
              "AWS/ApplicationELB",
              "HTTPCode_ELB_5XX_Count",
              "LoadBalancer",
              var.alb_arn_suffix
            ]
          ]

          stat   = "Sum"
          period = 300
          region = var.aws_region
        }
      },

      # Healthy Targets
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6

        properties = {
          title = "Healthy Targets"

          metrics = [
            [
              "AWS/ApplicationELB",
              "HealthyHostCount",
              "LoadBalancer",
              var.alb_arn_suffix,
              "TargetGroup",
              var.green_target_group_arn_suffix
            ]
          ]

          stat   = "Average"
          period = 300
          region = var.aws_region
        }
      },

      # Application Logs
      {
        type   = "log"
        x      = 0
        y      = 18
        width  = 24
        height = 6

        properties = {
          title = "Application Logs"

          query = <<EOF
SOURCE '/ecs/${var.project_name}'
| fields @timestamp, @message
| sort @timestamp desc
| limit 50
EOF

          region = var.aws_region
        }
      },
    ]
  })
}