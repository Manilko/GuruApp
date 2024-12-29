// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Delete All
  internal static let deleteAllButtonTitle = L10n.tr("Localization", "deleteAllButtonTitle", fallback: "Delete All")
  /// trash
  internal static let deleteImage = L10n.tr("Localization", "deleteImage", fallback: "trash")
  /// Favorite list is empty
  internal static let emptyLabelText = L10n.tr("Localization", "emptyLabelText", fallback: "Favorite list is empty")
  /// OK
  internal static let errorAlertActionTitle = L10n.tr("Localization", "errorAlertActionTitle", fallback: "OK")
  /// Error
  internal static let errorAlertTitle = L10n.tr("Localization", "errorAlertTitle", fallback: "Error")
  /// Localization.strings
  ///   myGuru
  /// 
  ///   Created by Yevhenii Manilko on 29.12.2024.
  internal static let headerFavoritesView = L10n.tr("Localization", "headerFavoritesView", fallback: "Favorites")
  /// Items
  internal static let headerItems = L10n.tr("Localization", "headerItems", fallback: "Items")
  /// Items
  internal static let headerItemView = L10n.tr("Localization", "headerItemView", fallback: "Items")
  /// Remove All
  internal static let removeFavoritesButtonTitle = L10n.tr("Localization", "removeFavoritesButtonTitle", fallback: "Remove All")
  /// heart.fill
  internal static let selectedFavoriteImage = L10n.tr("Localization", "selectedFavoriteImage", fallback: "heart.fill")
  /// heart
  internal static let unselectedFavoriteImage = L10n.tr("Localization", "unselectedFavoriteImage", fallback: "heart")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
