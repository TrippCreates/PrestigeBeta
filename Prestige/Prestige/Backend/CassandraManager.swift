import Foundation

class CassandraManager {
    static let shared = CassandraManager()
    private var session: OpaquePointer?
    
    private init() {
        setupCassandra()
    }
    
    private func setupCassandra() {
        // Initialize Cassandra cluster
        let cluster = cass_cluster_new()
        let session = cass_session_new()
        
        // Add contact points (Cassandra nodes)
        cass_cluster_set_contact_points(cluster, "localhost")
        
        // Set port (default is 9042)
        cass_cluster_set_port(cluster, 9042)
        
        // Connect to the cluster
        let future = cass_session_connect(session, cluster)
        cass_future_wait(future)
        
        // Check for connection errors
        let error_code = cass_future_error_code(future)
        if error_code != CASS_OK {
            let message = cass_future_error_message(future)
            print("Unable to connect to Cassandra: \(String(cString: message))")
        } else {
            self.session = session
            createKeyspaceAndTables()
        }
        
        cass_future_free(future)
        cass_cluster_free(cluster)
    }
    
    private func createKeyspaceAndTables() {
        // Create keyspace if it doesn't exist
        let createKeyspaceQuery = """
            CREATE KEYSPACE IF NOT EXISTS prestige
            WITH replication = {
                'class': 'SimpleStrategy',
                'replication_factor': 1
            }
        """
        
        // Create messages table
        let createMessagesTableQuery = """
            CREATE TABLE IF NOT EXISTS prestige.messages (
                message_id uuid,
                sender_id text,
                receiver_id text,
                content text,
                timestamp timestamp,
                is_read boolean,
                PRIMARY KEY ((sender_id, receiver_id), timestamp)
            ) WITH CLUSTERING ORDER BY (timestamp DESC)
        """
        
        executeQuery(createKeyspaceQuery)
        executeQuery(createMessagesTableQuery)
    }
    
    private func executeQuery(_ query: String) {
        guard let session = session else { return }
        
        let statement = cass_statement_new(query, 0)
        let future = cass_session_execute(session, statement)
        cass_future_wait(future)
        
        let error_code = cass_future_error_code(future)
        if error_code != CASS_OK {
            let message = cass_future_error_message(future)
            print("Error executing query: \(String(cString: message))")
        }
        
        cass_future_free(future)
        cass_statement_free(statement)
    }
    
    // MARK: - Message Operations
    
    func sendMessage(senderId: String, receiverId: String, content: String) {
        let query = """
            INSERT INTO prestige.messages (message_id, sender_id, receiver_id, content, timestamp, is_read)
            VALUES (uuid(), ?, ?, ?, toTimestamp(now()), false)
        """
        
        guard let session = session else { return }
        let statement = cass_statement_new(query, 4)
        
        cass_statement_bind_string(statement, 0, senderId)
        cass_statement_bind_string(statement, 1, receiverId)
        cass_statement_bind_string(statement, 2, content)
        
        let future = cass_session_execute(session, statement)
        cass_future_wait(future)
        
        cass_future_free(future)
        cass_statement_free(statement)
    }
    
    func getMessages(between userId1: String, and userId2: String, limit: Int = 50) -> [[String: Any]] {
        let query = """
            SELECT * FROM prestige.messages
            WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)
            ORDER BY timestamp DESC
            LIMIT ?
        """
        
        guard let session = session else { return [] }
        let statement = cass_statement_new(query, 5)
        
        cass_statement_bind_string(statement, 0, userId1)
        cass_statement_bind_string(statement, 1, userId2)
        cass_statement_bind_string(statement, 2, userId2)
        cass_statement_bind_string(statement, 3, userId1)
        cass_statement_bind_int32(statement, 4, Int32(limit))
        
        let future = cass_session_execute(session, statement)
        cass_future_wait(future)
        
        var messages: [[String: Any]] = []
        
        if let result = cass_future_get_result(future) {
            let iterator = cass_iterator_from_result(result)
            
            while cass_iterator_next(iterator) {
                if let row = cass_iterator_get_row(iterator) {
                    var message: [String: Any] = [:]
                    
                    if let messageId = getStringValue(row: row, column: "message_id") {
                        message["messageId"] = messageId
                    }
                    if let senderId = getStringValue(row: row, column: "sender_id") {
                        message["senderId"] = senderId
                    }
                    if let receiverId = getStringValue(row: row, column: "receiver_id") {
                        message["receiverId"] = receiverId
                    }
                    if let content = getStringValue(row: row, column: "content") {
                        message["content"] = content
                    }
                    if let timestamp = getTimestampValue(row: row, column: "timestamp") {
                        message["timestamp"] = timestamp
                    }
                    if let isRead = getBoolValue(row: row, column: "is_read") {
                        message["isRead"] = isRead
                    }
                    
                    messages.append(message)
                }
            }
            
            cass_iterator_free(iterator)
            cass_result_free(result)
        }
        
        cass_future_free(future)
        cass_statement_free(statement)
        
        return messages
    }
    
    // MARK: - Helper Methods
    
    private func getStringValue(row: OpaquePointer, column: String) -> String? {
        var value: UnsafePointer<Int8>?
        var value_length: Int = 0
        
        if cass_value_get_string(cass_row_get_column_by_name(row, column), &value, &value_length) == CASS_OK {
            let buffer = UnsafeBufferPointer(start: value, count: value_length)
            return String(bytes: buffer.map { UInt8(bitPattern: $0) }, encoding: .utf8)
        }
        return nil
    }
    
    private func getTimestampValue(row: OpaquePointer, column: String) -> Date? {
        var timestamp: Int64 = 0
        
        if cass_value_get_int64(cass_row_get_column_by_name(row, column), &timestamp) == CASS_OK {
            return Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
        }
        return nil
    }
    
    private func getBoolValue(row: OpaquePointer, column: String) -> Bool? {
        var value: cass_bool_t = 0
        
        if cass_value_get_bool(cass_row_get_column_by_name(row, column), &value) == CASS_OK {
            return value == cass_true
        }
        return nil
    }
    
    deinit {
        if let session = session {
            cass_session_free(session)
        }
    }
} 
