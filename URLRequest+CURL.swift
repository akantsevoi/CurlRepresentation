extension URLRequest {
    
    func escapeQuotes(in string: String) -> String {
        return string.replacingOccurrences(of: "\"", with: "\\\"")
    }
    
    func curlRepresentation() -> String {
        let _httpMethod = self.httpMethod ?? ""
        var curlString = "curl -v -X \(_httpMethod)"
        
        if let headerFields = allHTTPHeaderFields {
            for (key, value) in headerFields {
                curlString.append(" -H \"\(escapeQuotes(in: key)): \(escapeQuotes(in: value))\"")
            }
        }
        
        
        
        if let bodyData = self.httpBody,
            let bodyString = String(data: bodyData, encoding: .utf8),
            bodyString.count > 0 {
            curlString.append(" -d '\(bodyString)'")
        }
        
        if let absoluteString = self.url?.absoluteString {
            curlString.append(" \"\(escapeQuotes(in: absoluteString))\"")
        }
        
        return curlString
    }
    
    func curlRepresentation(with session: URLSession) -> String {
        var curlString = curlRepresentation()
        
        if let additionalHeaders = session.configuration.httpAdditionalHeaders as? [String: String] {
            for (key, value) in additionalHeaders {
                curlString.append(" -H \"\(escapeQuotes(in: key)): \(escapeQuotes(in: value))\"")
            }
        }
        
        return curlString
    }
}
