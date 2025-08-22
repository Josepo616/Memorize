struct AddThemeButton: View {
    @ObservedObject var viewModel: ThemeViewModel
    @Binding var isPopoverVisible: Bool
    
    var body: some View {
        Button {
            isPopoverVisible.toggle()
        } label: {
            Text("Add Theme")
            Image(systemName: "plus.square.fill.on.square.fill")
        }
        .popover(isPresented: $isPopoverVisible) {
            if let themeId = viewModel.selectedThemeId,
               let _ = viewModel.getThemeById(themeId) {
                ThemeFormView(
                    viewModel: viewModel,
                    themeId: $viewModel.selectedThemeId
                )
            } else {
                ThemeFormView(
                    viewModel: viewModel,
                    themeId: $viewModel.selectedThemeId
                )
            }
        }
    }
}
