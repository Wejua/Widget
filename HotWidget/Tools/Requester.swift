//
//  Requester.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/8.
//

import Foundation

struct Requester {
    
    enum RequestMethod: Int, CaseIterable {
        case GET
        case POST
    }
    
    static func request<T:Codable>(method: RequestMethod, urlString: String, parameters:[String:Any]?, mapModel: T.Type, completionInMain:@escaping (_ model: T?, _ error: Error?) -> Void) {
        Requester.request(method: .GET, urlString: urlString, parameters: parameters) { data, error in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                decoder.nonConformingFloatDecodingStrategy =  .convertFromString(positiveInfinity: "+veInfinity", negativeInfinity: "-veInfinity", nan: "nan")
                let model = try decoder.decode(T.self, from: data)
                completionInMain(model, nil)
            } catch let error {
                fatalError("Error decoding: \(error)")
            }
        }
    }

    static func request(method: RequestMethod, urlString: String, parameters: [String:Any]?, completionInMain:@escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let url = URL(string: "http://hotwidget/api/component/list") else {
            fatalError("URL格式错误")
        }
        
        var urlRequest: URLRequest
        if (method == .GET) {
            let queryItems = parameters?.map({ (key: String, value: Any) in
                URLQueryItem(name: key, value: value as? String)
            })
            var components = URLComponents(string: urlString)
            components?.queryItems = queryItems
            guard let url = components?.url else { return }
            
            urlRequest = URLRequest(url: url)
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        } else {
            urlRequest = URLRequest(url: url)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.httpMethod = "POST"
            if let body = parameters {
                let jsonBody = try? JSONSerialization.data(withJSONObject: body)
                urlRequest.httpBody = jsonBody
            }
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    completionInMain(data, nil)
                } else {
                    completionInMain(nil, error)
                }
            }
        }
        
        dataTask.resume()
    }
    
}



