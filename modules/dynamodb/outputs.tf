output "name" {
    value = var.billing_mode != "AUTOSCALED" ? aws_dynamodb_table.standard[0].name : aws_dynamodb_table.autoscaled[0].name
    description = "The name of the table."
}

output "arn" {
    value = var.billing_mode != "AUTOSCALED" ? aws_dynamodb_table.standard[0].arn : aws_dynamodb_table.autoscaled[0].arn
    description = "The arn of the table."
}

output "stream_arn" {
    value = var.billing_mode != "AUTOSCALED" ? aws_dynamodb_table.standard[0].stream_arn : aws_dynamodb_table.autoscaled[0].stream_arn
    description = "The arn of the Table Stream."
}

output "stream_label" {
    value = var.billing_mode != "AUTOSCALED" ? aws_dynamodb_table.standard[0].stream_label : aws_dynamodb_table.autoscaled[0].stream_label
    description = "A timestamp, in ISO 8601 format, for this stream. Note that this timestamp is not a unique identifier for the stream on its own. However, the combination of AWS customer ID, table name and this field is guaranteed to be unique. It can be used for creating CloudWatch Alarms."
}