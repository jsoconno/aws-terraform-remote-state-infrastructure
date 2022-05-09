output "name" {
    value = aws_dynamodb_table.standard.name
    description = "The name of the table."
}

output "arn" {
    value = aws_dynamodb_table.standard.arn
    description = "The arn of the table."
}

output "stream_arn" {
    value = aws_dynamodb_table.standard.stream_arn
    description = "The arn of the Table Stream."
}

output "stream_label" {
    value = aws_dynamodb_table.standard.stream_label
    description = "A timestamp, in ISO 8601 format, for this stream. Note that this timestamp is not a unique identifier for the stream on its own. However, the combination of AWS customer ID, table name and this field is guaranteed to be unique. It can be used for creating CloudWatch Alarms."
}