import Vapor
import JWT

private enum Constants {
  static let expirationTime = TimeInterval(60 * 60 * 24)
}

public extension JWKIdentifier {
  static let sessionToken = JWKIdentifier(string: "sessionToken")
}

public struct SessionToken: Content, Authenticatable, JWTPayload {
  public let issuedAt: IssuedAtClaim
  public let expiration: ExpirationClaim
  public let userId: UUID

  public init(userId: UUID, issuedAt:
       IssuedAtClaim = .init(value: Date()))
  {
    self.userId = userId
    self.issuedAt = issuedAt
    self.expiration = .init(
      value: Date().addingTimeInterval(Constants.expirationTime)
    )
  }

  public func verify(using signer: JWTSigner) throws {
    try expiration.verifyNotExpired()
  }
}

public enum Signer {
  public static func registerDefault(_ app: Application) {
    guard let key = Environment.get("SIGNER_KEY") else {
      fatalError("Signer key was not set, check 'SIGNER_KEY' env variable")
    }
    app.jwt.signers.use(.hs256(key: key), kid: .sessionToken)
  }
}

public extension Request {
  func sessionToken() throws -> SessionToken {
    try auth.require(SessionToken.self)
  }
}
