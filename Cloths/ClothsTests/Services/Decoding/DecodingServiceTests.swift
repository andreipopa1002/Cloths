import XCTest
@testable import Cloths

final class DecodingServiceTests: XCTestCase {
    private var mockedNetworkService: MockNetworkService!
    private var mockedDecoder: MockDecoder!
    private var service: DecodingService!
    private let request = URLRequest(url: URL(string: "www.g.c")!)
    private var inferingResult: Result<DummyDecodable, Error>?

    override func setUp() {
        super.setUp()

        mockedNetworkService = MockNetworkService()
        mockedDecoder = MockDecoder()
        service = DecodingService(service: mockedNetworkService, decoder: mockedDecoder)
    }

    override func tearDown() {
        mockedNetworkService = nil
        mockedDecoder = nil
        service = nil

        super.tearDown()
    }

    func test_GivenRequest_WhenFetch_ThenNetworkServiceFetchWithRequest() {
        service.fetch(request: request) { self.inferingResult = $0 }
        XCTAssertEqual(mockedNetworkService.spyRequest, [request])
    }

    func test_GivenSuccessWithData_WhenFetch_ThenDecoderDecodeSameData() {
        service.fetch(request: request) { self.inferingResult = $0 }

        let stubbedData = Data()
        mockedNetworkService.spyCompletion?(.success(stubbedData))
        XCTAssertEqual(mockedDecoder.spyData, [stubbedData])
    }

    func test_GivenSuccessWithNilData_WhenFetch_ThenFailureWithErrorDescription() {
        service.fetch(request: request) { self.inferingResult = $0 }

        mockedNetworkService.spyCompletion?(.success(nil))
        XCTAssertEqual(
            capturedErrorFromInferredResult()?.localizedDescription,
            "no data received"
        )
    }

    func test_GivenFailureWithData_WhenFetch_ThenFailureWithSameError() {
        service.fetch(request: request) { self.inferingResult = $0 }

        mockedNetworkService.spyCompletion?(.failure(DummyError(customDescription: "network failure")))
        XCTAssertEqual(
            capturedErrorFromInferredResult()?.localizedDescription,
            "network failure"
        )
    }

    func test_GivenDecodingFails_WhenFetch_ThenFailWithSameError() {
        service.fetch(request: request) { self.inferingResult = $0 }
        mockedDecoder.stubbedResult = .failure(DummyError(customDescription: "failed to decode"))
        mockedNetworkService.spyCompletion?(.success(Data()))
        XCTAssertEqual(
            capturedErrorFromInferredResult()?.localizedDescription,
            "failed to decode"
        )
    }

    func test_GivenDecodingSuccess_WhenFetch_ThenSuccessWithModel() {
        service.fetch(request: request) { self.inferingResult = $0 }
        mockedDecoder.stubbedResult = .success(DummyDecodable())
        mockedNetworkService.spyCompletion?(.success(Data()))

        XCTAssertNotNil(capturedModelFromInferredResult())
    }
}

private extension DecodingServiceTests {
    func capturedErrorFromInferredResult() -> Error? {
        if case.failure(let error) = self.inferingResult {
            return error
        }

        return nil
    }

    func capturedModelFromInferredResult() -> DummyDecodable? {
        if case .success(let model) = self.inferingResult {
            return model
        }

        return nil
    }
}

private struct DummyDecodable: Decodable { }
