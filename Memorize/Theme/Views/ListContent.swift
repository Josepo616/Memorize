// MARK: - List Content Abstraction
struct ListContent: View {
    let theme: ThemeModel
    
    var body: some View {
        Text(theme.displayName)
            .font(.headline)
            .foregroundColor(Colors().mapColor(theme.associatedColor))
        Text(theme.emojiElements.prefix(10).joined(separator: " "))
            .font(.body)
        Text(
            (theme.amountOfCards != nil)
            ? "Max amount of cards: \(theme.amountOfCards!)"
            : "You are using a random amount of cards"
        )
        .font(.footnote)
    }
}
