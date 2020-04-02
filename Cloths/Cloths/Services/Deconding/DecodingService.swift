import Foundation

protocol DecodingServiceInterface {
    func fetch<DecodableModel: Decodable>(request: URLRequest, completion: @escaping (Result<DecodableModel, Error>) -> ())
}

struct NoDataError: LocalizedError {
    let customDescription: String
    var errorDescription: String? {
        return customDescription
    }
}

final class DecodingService {
    private let service: NetworkServiceInterface
    private let decoder: DecoderInterface

    init(
        service: NetworkServiceInterface,
        decoder: DecoderInterface
    ) {
        self.service = service
        self.decoder = decoder

    }
}

extension DecodingService: DecodingServiceInterface {
    func fetch<DecodableModel>(request: URLRequest, completion:@escaping (Result<DecodableModel, Error>) -> ()) where DecodableModel : Decodable {
        service.fetch(request: request) { [weak self] result in
            self?.handleNetworkResult(result: result, completion: completion)
        }
    }
}

private extension DecodingService {
    func handleNetworkResult<DecodableModel>(result: NetworkResult, completion: @escaping (Result<DecodableModel, Error>) -> ()) where DecodableModel: Decodable {
        switch result {
        case .success(let data):
            guard let data = data else {
                return completion(.failure(NoDataError(customDescription: "no data received")))
            }

            decodeModel(fromData: data, completion: completion)
        case .failure(let error):
            completion(.failure(error))
        }
    }

    func decodeModel<DecodableModel>(fromData data: Data, completion: @escaping (Result<DecodableModel, Error>) -> ()) where DecodableModel : Decodable {
        do {
            let model = try self.decoder.decode(DecodableModel.self, from: data)
            completion(.success(model))
        } catch  {
            completion(.failure(error))
        }
    }
}
