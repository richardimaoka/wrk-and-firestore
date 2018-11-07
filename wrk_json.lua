-- example script for creating json file report

function done(summary, latency, requests)
  file = io.open('result_intermediate.json', 'w')
  io.output(file)

  io.write(string.format("{\n"))

  io.write(string.format("  \"summary\": {\n"))
  io.write(string.format("    \"duration_microseconds\": %d,\n",      summary.duration))
  io.write(string.format("    \"num_requests\":          %d,\n",      summary.requests))
  io.write(string.format("    \"total_bytes\":           %d,\n",      summary.bytes))
  io.write(string.format("    \"requests_per_sec\":      %.2f,\n",    summary.requests/(summary.duration)))
  io.write(string.format("    \"bytes_per_sec\":         \"%.2f\"\n", summary.bytes/summary.duration))
  io.write(string.format("  },\n"))

  io.write(string.format("  \"latency\": {\n"))
  io.write(string.format("    \"min_microseconds\":           %.2f,\n", latency.min))
  io.write(string.format("    \"max_microseconds\":           %.2f,\n", latency.max))
  io.write(string.format("    \"mean_microseconds\":          %.2f,\n", latency.mean))
  io.write(string.format("    \"stdev_microseconds\":         %.2f,\n", latency.stdev))
  io.write(string.format("    \"percentile_90_microseconds\": %.2f,\n", latency:percentile(90.0)))
  io.write(string.format("    \"percentile_95_microseconds\": %.2f,\n", latency:percentile(95.0)))
  io.write(string.format("    \"percentile_99_microseconds\": %.2f\n",  latency:percentile(99.0)))
  io.write(string.format("  }\n"))

   
  io.write(string.format("}\n"))
end

