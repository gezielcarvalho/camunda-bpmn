# Elasticsearch Backup Script

# Register a filesystem repository for snapshots
curl -u elastic:changeme -X PUT "http://localhost:9200/_snapshot/es_local" \
  -H 'Content-Type: application/json' \
  -d '{
    "type": "fs",
    "settings": {
      "location": "/usr/share/elasticsearch/backup",
      "compress": true
    }
  }'

# Create a snapshot
curl -u elastic:changeme -X PUT "http://localhost:9200/_snapshot/es_local/snapshot_$(date +%Y%m%d_%H%M%S)" \
  -H 'Content-Type: application/json' \
  -d '{
    "indices": "*",
    "ignore_unavailable": true,
    "include_global_state": false
  }'

echo "Backup initiated. Check status with:"
echo "curl -u elastic:changeme http://localhost:9200/_snapshot/es_local/_all"
