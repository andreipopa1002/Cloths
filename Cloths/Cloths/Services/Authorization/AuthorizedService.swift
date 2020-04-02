import Foundation

protocol APIKeyProviderInterface {
    var apiKey: String {get}
}

final class AuthorizedService {
    private let service: NetworkServiceInterface
    private let tokenProvider: APIKeyProviderInterface

    init(service: NetworkServiceInterface, tokenProvider: APIKeyProviderInterface) {
        self.service = service
        self.tokenProvider = tokenProvider
    }
}

extension AuthorizedService: NetworkServiceInterface {
    func fetch(request: URLRequest, completion: @escaping NetworkServiceCompletion) {
        var request = request
        request.addValue(tokenProvider.apiKey, forHTTPHeaderField: "X-API-KEY")
        service.fetch(request: request, completion: completion)
    }
}

struct TokenProvider: APIKeyProviderInterface {
    var apiKey: String {
        return "eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAH1TQZKbMBD8yhbnnS0wsGBuueUDecBoNLJVBomSxCZbqfw9AoExzlZudPdMq0cjfmfa-6zLcNQgebBvPqDrtbkINLc3skP2mvlJxArRlCiQGsDzSUFFsgVR4js0bVm3jSxFJZpYzL_GrCvqtq6bqjnVr5nGkIiqbcuZQCI7mfDd9pLdDy2jd13mVVMoCSeSOVS5YBCFPIHIm3NdieJE2EbvYG9sUkdZc63O1RlUeY4dmFcgmBnKUiqV56qmAmNHHOsbEXufugpVNVQJCe-YC6hETnDOEaFVdJIF1bLEeh6Y7MjzpaSkcF2igsGBO8coX56E8Dk-CVqyCVppdke-1z4cmBVI6WLIjqUOd5CUEJCuA98rd_zT6cAvOIWrddrHlYE2Un9oOWGfigX2aGiNRugkkDXB2T4dNDOrZo3SbsCgrQGrQE1G-rvk76dvIB1Nkw922EbkAfVqPKCRGLiT3HOs2-BSNqC7cZjTjo4VO44B_f-kdFbSxh6J45iBL24J-9j4r7i2sqMrbiMMHDCmwY4iXNQVL8lH_GTepATWIRLYi0APeFlnStr2CWLqb922F96p3Tbh3Tnhu0FvKa7woXwhwM67fGbXLmeV7rdQKeWBWqocE-sxHIA_SunKPH7ENXi42D3HgVujH7jF55GB4ND4uMivLHbxC69dTKYhvqD5XVgnH9yO7GZzZLf-wPM_A-Q_nqlRqpWahCcXL-H-rpYUSAux3OkjMVdkf_4Cgcaj30AFAAA.cIWC15WM9gSkssgkPldF--GRSgp1-CiGjTC1MdgPYIP4a9a_fWHVqH39eul1TsmqTzFbg9zZQJxQPmlqoVSC_RxxsHcNfiv3uyanGnksW1nmD_NiD7fnpm9Rw-SUGC7bW7M0_cXiShHlihJMEfdjH3a_XiP5TqKLYsk9iQ7ZLiWKDJglb5S1wHXBpsd0OydEzSYY1DEU4DyB5vVz7EQn27t70tzMB2TFmXlq1MhZ8SUR52_9dLYSveacRmUSMX8Mluw-aOl9WxphdvnPQYvvC_35IUGZ-ZbYWShPe9SNBqPUxO9uNHKWAI55SsF8yUOSRDtopUE9fAahAuX2E92Axmz5es4XP_5v18mVk174TKp0pRJKJ4E1ReRplEQ_jioaU4FAQN6Niw3XfX0qBjeOKmHGC7on9AoSFvcTlKtTsVbPFGO91-Te5ErboPAzs3HapNNdvWifXkyxNAOb43cKE_SzW6SlFbVbMhQFoRVph70bvtyXQ_1OgA0ww2MQXMfODBH3CGtIycIrH3S778cvcg4tEyYRfpCgTYQZ93_rIvlwv-3Xu05cO_yAzPXWO0yqLuP7sgbroGXizYLaODDm4seyYGl-x5itGVIV6ggSLtGliDclJjWRb1-Mvrbo0NLwPtPKgkCQIIsy7U2K2Li-CSSu1pLCUV4wmv8TDBfKnLU"
    }
}
