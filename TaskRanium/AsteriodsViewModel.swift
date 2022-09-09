//
//  AsteriodsViewModel.swift
//  TaskRanium
//
//  Created by Sunil Uppin on 09/09/22.
//

import Foundation

class AsteriodsViewModel {
    
    let decoder = JSONDecoder()
    let sharedSession = URLSession.shared
    
    var asteriodsValue: AsteriodsDataModel?
    
    func getAsteriodDetails(_ startDate: String,
                          _ endDate: String,
                          completion: @escaping (_ e: NSError? ) -> Void ) {
    
        if let url = URL(string: "https://api.nasa.gov/neo/rest/v1/feed?start_date=\(startDate)&end_date=\(endDate)&api_key=DEMO_KEY") {
            let request = URLRequest(url: url)
            
            let dataTask = sharedSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if let data = data {
                    debugPrint(data)
                    self.asteriodsValue = try? self.decoder.decode(AsteriodsDataModel.self, from: data)
                    completion(nil)
                }
            })
            dataTask.resume()
        }
    }
}
