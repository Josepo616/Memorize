// MARK: - Context Menu Abstraction
struct ThemeContextMenu: View {
    @ObservedObject var viewModel: ThemeViewModel
    let themeModel: ThemeModel
    @Binding var isPopoverVisible: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.selectedThemeId = themeModel.id
                isPopoverVisible.toggle()
            }) {
                Text("Edit")
                Image(systemName: "pencil")
            }
            
            Button(action: {
                viewModel.deleteTheme(themeModel.id)
            }) {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }
}
