module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${compact(concat(var.attributes, list("log"), list("group")))}"
  tags       = "${var.tags}"
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "${module.label.id}"
  retention_in_days = "${var.retention_in_days}"
  tags              = "${module.label.tags}"
  kms_key_id        = "${var.kms_key_arn}"
}

resource "aws_cloudwatch_log_stream" "default" {
  count          = "${length(var.stream_names) > 0 ? length(var.stream_names) : 0}"
  name           = "${element(var.stream_names, count.index)}"
  log_group_name = "${aws_cloudwatch_log_group.default[*].name}"
}
