//
//  Multipart.swift
//  MovieBookingApp
//
//  Created by KC on 05/04/2022.
//

/**
    This code is based on the following resouces.
    https://www.donnywals.com/uploading-images-and-forms-to-a-server-using-urlsession/
    https://orjpap.github.io/swift/http/ios/urlsession/2021/04/26/Multipart-Form-Requests.html
    https://github.com/Datt1994/DPMultiPartSwift
 
 
    Sample multipart/form-data;
 
     --Boundary-3A42CBDB-01A2-4DDE-A9EE-425A344ABA13
     Content-Disposition: form-data; name="name"

     Thet Tun
     --Boundary-3A42CBDB-01A2-4DDE-A9EE-425A344ABA13
     Content-Disposition: form-data; name="township"

     Yangon
     --Boundary-3A42CBDB-01A2-4DDE-A9EE-425A344ABA13
     Content-Disposition: form-data; name="file"; filename="somefilename.jpg"
     Content-Type: image/png

     -a long string of image data-
     --Boundary-3A42CBDB-01A2-4DDE-A9EE-425A344ABA13—
 
 
     BOUNDARY
     CONTENT TYPE
     -- BLANK LINE --
     VALUE
 */

import UIKit

struct MultiPartFileData {
    let formFieldName : String
    let fileName : String
    let data : Data
    let mimeType : String
}

class MultiPart {
    
    static let shared = MultiPart()
    
    private init() { }
    
    func buildFormData(
        urlStr : String,
        params: [String:Any]?,
        fileData: [MultiPartFileData]?) -> (URLRequest, Data) {
        
        // set boundary
        let boundary = "Boundary-\(UUID().uuidString)"
        
        // configure the request
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "POST"
        
        // set content type
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create body
        let httpBody: Data? = createBody(withBoundary: boundary, parameters: params, filesData: fileData)
        
        return (request, httpBody ?? Data())
    }
    
    fileprivate func createBody(
        withBoundary boundary: String,
        parameters: [String: Any]?,
        filesData: [MultiPartFileData]?) -> Data {
        
        let httpBody = NSMutableData()
        
        // add text form-field
        if let parameters = parameters {
            for (parameterKey, parameterValue) in parameters {
                httpBody.append("--\(boundary)\r\n")
                httpBody.append("Content-Disposition: form-data; name=\"\(parameterKey)\"\r\n")
                httpBody.append("\r\n")
                httpBody.append("\(parameterValue)\r\n")
            }
        }
        
        // add data form-field
        if let list = filesData {
            list.forEach { item in
                httpBody.append("--\(boundary)\r\n")
                httpBody.append("Content-Disposition: form-data; name=\"\(item.formFieldName)\"; filename=\"\(item.fileName)\"\r\n")
                httpBody.append("Content-Type: \(item.mimeType)\r\n")
                httpBody.append("\r\n")
                httpBody.append(item.data)
                httpBody.append("\r\n")
            }
        }
        
        // IMPORTANT! - close boundary
        httpBody.append("--\(boundary)--")
        
        return httpBody as Data
    }

    
}

extension NSMutableData {
  func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
