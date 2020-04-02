import Foundation

typealias NetworkResult = Result<Data?, Error>
typealias NetworkServiceCompletion = (NetworkResult) -> ()

protocol NetworkServiceInterface {
    func fetch(request: URLRequest, completion:@escaping NetworkServiceCompletion)
}

final class NetworkService {
    private let framework: NetworkFrameworkInterface
    
    init(with framework: NetworkFrameworkInterface) {
        self.framework = framework
    }
}

extension NetworkService: NetworkServiceInterface {

    func fetch(request: URLRequest, completion:@escaping NetworkServiceCompletion) {
        let dataTask = framework.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else  {
                completion(.success(data))
            }
        }
        dataTask.resume()
    }
}
