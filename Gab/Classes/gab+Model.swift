//
//  gab+Model.swift
//  gab.swift
//
//  Created by Tomoya Hirano on 2018/08/28.
//

import Foundation

public struct Feed: Codable {
  public let data: [Status]
  public let noMore: Bool
  
  enum CodingKeys: String, CodingKey {
    case data
    case noMore = "no-more"
  }
}

public struct Status: Codable {
  public let id: String
  public let publishedAt: Date
  public let type: PostMode
  public let actuser: User
  public let post: Post
  
  enum CodingKeys: String, CodingKey {
    case id
    case publishedAt = "published_at"
    case type, actuser, post
  }
}

public struct User: Codable {
  public let id: Int
  public let name: String
  public let username: String
  public let pictureURL: String
  public let verified, isDonor, isInvestor, isPro: Bool
  public let isPrivate, isPremium: Bool
  
  enum CodingKeys: String, CodingKey {
    case id, name, username
    case pictureURL = "picture_url"
    case verified
    case isDonor = "is_donor"
    case isInvestor = "is_investor"
    case isPro = "is_pro"
    case isPrivate = "is_private"
    case isPremium = "is_premium"
  }
}

public struct Post: Codable {
  public let id: Int
  public let createdAt: Date
  public let revisedAt: JSONNull?
  public let edited: Bool
  public let body: String
  public let bodyHTML, bodyHTMLSummary: String?
  public let bodyHTMLSummaryTruncated, onlyEmoji, liked, disliked: Bool
  public let bookmarked, repost, reported: Bool
  public let score, likeCount, dislikeCount, replyCount: Int
  public let repostCount: Int
  public let isQuote, isReply, isRepliesDisabled: Bool
  public let embed: Embed
  public let attachment: Attachment
  public let category, categoryDetails: JSONNull?
  public let language: String?
  public let nsfw, isPremium, isLocked: Bool
  public let user: User
  public let replies: Replies
  
  enum CodingKeys: String, CodingKey {
    case id
    case createdAt = "created_at"
    case revisedAt = "revised_at"
    case edited, body
    case bodyHTML = "body_html"
    case bodyHTMLSummary = "body_html_summary"
    case bodyHTMLSummaryTruncated = "body_html_summary_truncated"
    case onlyEmoji = "only_emoji"
    case liked, disliked, bookmarked, repost, reported, score
    case likeCount = "like_count"
    case dislikeCount = "dislike_count"
    case replyCount = "reply_count"
    case repostCount = "repost_count"
    case isQuote = "is_quote"
    case isReply = "is_reply"
    case isRepliesDisabled = "is_replies_disabled"
    case embed, attachment, category
    case categoryDetails = "category_details"
    case language, nsfw
    case isPremium = "is_premium"
    case isLocked = "is_locked"
    case user, replies
  }
}

public struct Attachment: Codable {
  public let type: String?
  public let value: Value?
}

public struct Value: Codable {
  public let image, title, description, url: String
  public let source: String
}

public struct Embed: Codable {
  public let html: String?
  public let iframe: Bool?
}

public struct Replies: Codable {
  public let data: [JSONAny]
}

public enum PostMode: String, Codable {
  case post = "post"
  case repost = "repost"
}

// MARK: Encode/decode helpers

public class JSONNull: Codable {
  public init() {}
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if !container.decodeNil() {
      throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encodeNil()
  }
}

public class JSONCodingKey: CodingKey {
  let key: String
  
  required public init?(intValue: Int) {
    return nil
  }
  
  required public init?(stringValue: String) {
    key = stringValue
  }
  
  public var intValue: Int? {
    return nil
  }
  
  public var stringValue: String {
    return key
  }
}

public class JSONAny: Codable {
  public let value: Any
  
  static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
    let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
    return DecodingError.typeMismatch(JSONAny.self, context)
  }
  
  static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
    let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
    return EncodingError.invalidValue(value, context)
  }
  
  static func decode(from container: SingleValueDecodingContainer) throws -> Any {
    if let value = try? container.decode(Bool.self) {
      return value
    }
    if let value = try? container.decode(Int64.self) {
      return value
    }
    if let value = try? container.decode(Double.self) {
      return value
    }
    if let value = try? container.decode(String.self) {
      return value
    }
    if container.decodeNil() {
      return JSONNull()
    }
    throw decodingError(forCodingPath: container.codingPath)
  }
  
  static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
    if let value = try? container.decode(Bool.self) {
      return value
    }
    if let value = try? container.decode(Int64.self) {
      return value
    }
    if let value = try? container.decode(Double.self) {
      return value
    }
    if let value = try? container.decode(String.self) {
      return value
    }
    if let value = try? container.decodeNil() {
      if value {
        return JSONNull()
      }
    }
    if var container = try? container.nestedUnkeyedContainer() {
      return try decodeArray(from: &container)
    }
    if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
      return try decodeDictionary(from: &container)
    }
    throw decodingError(forCodingPath: container.codingPath)
  }
  
  static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
    if let value = try? container.decode(Bool.self, forKey: key) {
      return value
    }
    if let value = try? container.decode(Int64.self, forKey: key) {
      return value
    }
    if let value = try? container.decode(Double.self, forKey: key) {
      return value
    }
    if let value = try? container.decode(String.self, forKey: key) {
      return value
    }
    if let value = try? container.decodeNil(forKey: key) {
      if value {
        return JSONNull()
      }
    }
    if var container = try? container.nestedUnkeyedContainer(forKey: key) {
      return try decodeArray(from: &container)
    }
    if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
      return try decodeDictionary(from: &container)
    }
    throw decodingError(forCodingPath: container.codingPath)
  }
  
  static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
    var arr: [Any] = []
    while !container.isAtEnd {
      let value = try decode(from: &container)
      arr.append(value)
    }
    return arr
  }
  
  static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
    var dict = [String: Any]()
    for key in container.allKeys {
      let value = try decode(from: &container, forKey: key)
      dict[key.stringValue] = value
    }
    return dict
  }
  
  static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
    for value in array {
      if let value = value as? Bool {
        try container.encode(value)
      } else if let value = value as? Int64 {
        try container.encode(value)
      } else if let value = value as? Double {
        try container.encode(value)
      } else if let value = value as? String {
        try container.encode(value)
      } else if value is JSONNull {
        try container.encodeNil()
      } else if let value = value as? [Any] {
        var container = container.nestedUnkeyedContainer()
        try encode(to: &container, array: value)
      } else if let value = value as? [String: Any] {
        var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
        try encode(to: &container, dictionary: value)
      } else {
        throw encodingError(forValue: value, codingPath: container.codingPath)
      }
    }
  }
  
  static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
    for (key, value) in dictionary {
      let key = JSONCodingKey(stringValue: key)!
      if let value = value as? Bool {
        try container.encode(value, forKey: key)
      } else if let value = value as? Int64 {
        try container.encode(value, forKey: key)
      } else if let value = value as? Double {
        try container.encode(value, forKey: key)
      } else if let value = value as? String {
        try container.encode(value, forKey: key)
      } else if value is JSONNull {
        try container.encodeNil(forKey: key)
      } else if let value = value as? [Any] {
        var container = container.nestedUnkeyedContainer(forKey: key)
        try encode(to: &container, array: value)
      } else if let value = value as? [String: Any] {
        var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
        try encode(to: &container, dictionary: value)
      } else {
        throw encodingError(forValue: value, codingPath: container.codingPath)
      }
    }
  }
  
  static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
    if let value = value as? Bool {
      try container.encode(value)
    } else if let value = value as? Int64 {
      try container.encode(value)
    } else if let value = value as? Double {
      try container.encode(value)
    } else if let value = value as? String {
      try container.encode(value)
    } else if value is JSONNull {
      try container.encodeNil()
    } else {
      throw encodingError(forValue: value, codingPath: container.codingPath)
    }
  }
  
  public required init(from decoder: Decoder) throws {
    if var arrayContainer = try? decoder.unkeyedContainer() {
      self.value = try JSONAny.decodeArray(from: &arrayContainer)
    } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
      self.value = try JSONAny.decodeDictionary(from: &container)
    } else {
      let container = try decoder.singleValueContainer()
      self.value = try JSONAny.decode(from: container)
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    if let arr = self.value as? [Any] {
      var container = encoder.unkeyedContainer()
      try JSONAny.encode(to: &container, array: arr)
    } else if let dict = self.value as? [String: Any] {
      var container = encoder.container(keyedBy: JSONCodingKey.self)
      try JSONAny.encode(to: &container, dictionary: dict)
    } else {
      var container = encoder.singleValueContainer()
      try JSONAny.encode(to: &container, value: self.value)
    }
  }
}
