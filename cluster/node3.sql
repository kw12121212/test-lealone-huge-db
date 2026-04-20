-- Node 3 config (port 9212)

set lealone (
    base_dir: '${PROJECT_ROOT}/cluster/data/node3',
    listen_address: '127.0.0.1',
    log: (
        type: 'file',
        level: 'info'
    ),
    scheduler: (
        prefer_batch_write: false,
        max_packet_count_per_loop: 10,
    ),
    storage_engine: (
        name: 'AOSE',
        enabled: true,
        page_size: '16k',
        cache_size: '32m',
        compress: 'no'
    ),
    transaction_engine: (
        name: 'AOTE',
        enabled: true,
        log_sync_type: 'periodic'
    ),
    sql_engine: (
        name: 'Lealone',
        enabled: true,
    ),
    protocol_server_engine: (
        name: 'TCP',
        enabled: true,
        port: 9212,
        allow_others: true,
        ssl: false,
        session_timeout: -1
    )
)
